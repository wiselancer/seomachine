#!/bin/bash
# Entrypoint for the SEO Machine dev container. Mirrors the
# leadcognition_v2 dev-container pattern: auths GitHub, optionally
# clones dotfiles, brings up Tailscale if TS_AUTHKEY is set, then
# parks the container with a long-running tail.
set -e

DEV_HOME=/home/dev
DOTFILES_REPO="${DOTFILES_REPO:-}"
DOT="$DEV_HOME/.dotfiles"
WORKSPACE=/workspace
SEOMACHINE_DIR="$WORKSPACE/seomachine"

# ── Fix volume ownership (Docker mounts as root) ─────────────────────
mkdir -p "$WORKSPACE"
chown dev:dev "$DEV_HOME"
chown -R dev:dev "$WORKSPACE" 2>/dev/null || chown dev:dev "$WORKSPACE"

# ── GitHub auth (must happen BEFORE any clones — repos may be private) ─
if su - dev -c "GITHUB_TOKEN= gh auth status" &>/dev/null; then
    echo "GitHub auth: gh CLI (already logged in)"
    su - dev -c "git config --global --list" 2>/dev/null | grep '^url\.https://.*@github\.com' | cut -d= -f1 | while read key; do
        su - dev -c "git config --global --unset-all $key" 2>/dev/null || true
    done
    su - dev -c "GITHUB_TOKEN= gh auth setup-git"
elif [ -n "$GITHUB_TOKEN" ]; then
    echo "GitHub auth: GITHUB_TOKEN env (limited — run 'gh auth login' for full access)"
    su - dev -c "git config --global url.https://${GITHUB_TOKEN}@github.com/.insteadOf https://github.com/"
else
    echo "GitHub auth: none (run 'gh auth login' to set up)"
fi

# ── Clone seomachine repo on first boot ──────────────────────────────
if [ ! -d "$SEOMACHINE_DIR/.git" ]; then
    SEOMACHINE_REPO="${SEOMACHINE_REPO:-https://github.com/wiselancer/seomachine.git}"
    echo "Cloning seomachine: $SEOMACHINE_REPO"
    su - dev -c "git clone '$SEOMACHINE_REPO' '$SEOMACHINE_DIR'" \
        || echo "  Warning: seomachine clone failed (check GITHUB_TOKEN or run 'gh auth login')"
fi

# ── Pull canonical product docs (leadcognition_v2) on every boot ─────
if [ -x "$SEOMACHINE_DIR/scripts/sync-product-docs.sh" ]; then
    su - dev -c "cd '$SEOMACHINE_DIR' && ./scripts/sync-product-docs.sh" || \
        echo "  Warning: product-docs sync failed (non-fatal)"
fi

# ── Dotfiles (clone once, pull on restart) ────────────────────────────
if [ -n "$DOTFILES_REPO" ]; then
    if [ ! -d "$DOT" ]; then
        echo "Cloning dotfiles: $DOTFILES_REPO"
        su - dev -c "git clone $DOTFILES_REPO $DOT" || echo "  Warning: dotfiles clone failed"
    else
        echo "Updating dotfiles..."
        su - dev -c "git -C $DOT pull --ff-only" 2>/dev/null || true
    fi
    if [ -x "$DOT/remote/setup.sh" ]; then
        su - dev -c "$DOT/remote/setup.sh"
    fi
fi

# ── Fallback .zshrc (if dotfiles didn't provide one) ──────────────────
if [ ! -f "$DEV_HOME/.zshrc" ]; then
    cat > "$DEV_HOME/.zshrc" << 'ZSHRC'
HISTSIZE=50000; SAVEHIST=50000; HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS SHARE_HISTORY
bindkey -e
autoload -Uz compinit && compinit
autoload -Uz vcs_info; precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'
setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f${vcs_info_msg_0_} %F{green}❯%f '
alias ll='ls -la --color=auto'
alias gs='git status'
alias cc='claude --dangerously-skip-permissions'
export PATH="/usr/local/bin:$PATH"
cd /workspace/seomachine 2>/dev/null || cd /workspace
ZSHRC
    chown dev:dev "$DEV_HOME/.zshrc"
    echo "  Zsh: fallback config written"
fi

# ── Git config from env vars (overrides dotfiles) ────────────────────
if [ -n "$GIT_USER_NAME" ]; then
    su - dev -c "git config --global user.name '$GIT_USER_NAME'"
fi
if [ -n "$GIT_USER_EMAIL" ]; then
    su - dev -c "git config --global user.email '$GIT_USER_EMAIL'"
fi

# ── Tailscale (direct SSH into container) ──────────────────────────
if [ -n "$TS_AUTHKEY" ]; then
    mkdir -p /var/run/tailscale
    tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
    sleep 2
    tailscale up --authkey="$TS_AUTHKEY" --hostname="${TS_HOSTNAME:-seomachine-dev}" --ssh --advertise-tags=tag:container
    echo "  Tailscale: connected as $(tailscale ip -4 2>/dev/null || echo 'pending')"
fi

# ── Start tmux as dev user ───────────────────────────────────────────
su - dev -c "tmux new-session -d -s dev -c '$SEOMACHINE_DIR'" 2>/dev/null || true

echo "================================================"
echo "  SEO Machine dev container ready!"
echo "  User: dev (non-root) | Shell: zsh | Locale: $LANG"
echo "  Connect: docker exec -it -u dev <container> tmux attach -t dev"
echo "  Workspace: $SEOMACHINE_DIR"
[ -d "$DOT" ] && echo "  Dotfiles: $DOT"
echo "================================================"

exec tail -f /dev/null
