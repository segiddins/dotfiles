FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    zsh curl git sudo age vim locales \
    build-essential procps file \
    && rm -rf /var/lib/apt/lists/*

# Set up locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8

# Install chezmoi
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

# Create non-root user with passwordless sudo
RUN useradd -m -s /bin/zsh coder \
    && echo 'coder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER coder
WORKDIR /home/coder

# Copy repo as chezmoi source
COPY --chown=coder:coder . /home/coder/.local/share/chezmoi

# Pre-seed chezmoi config (non-interactive)
RUN mkdir -p /home/coder/.config/chezmoi && \
    echo '[data]' > /home/coder/.config/chezmoi/chezmoi.toml && \
    echo '    email = "test@example.com"' >> /home/coder/.config/chezmoi/chezmoi.toml && \
    echo '    personal = false' >> /home/coder/.config/chezmoi/chezmoi.toml && \
    echo '    server = false' >> /home/coder/.config/chezmoi/chezmoi.toml

# Entry point: apply dotfiles
ENTRYPOINT ["chezmoi"]
CMD ["apply", "-v"]
