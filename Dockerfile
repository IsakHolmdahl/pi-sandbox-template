FROM docker/sandbox-templates:shell-docker

USER root

# Install Node.js 24 from NodeSource
RUN apt-get update \
    && apt-get install -y curl ca-certificates gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
        | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_24.x nodistro main" \
        > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER agent

# agent-local npm "global" installs
RUN mkdir -p "$HOME/.npm-global" \
  && npm config set prefix "$HOME/.npm-global" \
  && printf '\n\# npm user-global prefix\nexport PATH="$HOME/.npm-global/bin:$PATH"\n' >> ~/.bashrc \
  && npm install -g --ignore-scripts @earendil-works/pi-coding-agent

RUN mkdir -p /home/agent/.pi/agent \
  && printf '\n\# Auto-launch pi coding agent in interactive shells\nif [[ $- == *i* ]] && command -v pi &> /dev/null; then\n    exec pi\nfi\n' >> ~/.bashrc

COPY --chown=agent:agent pi-packages.txt /home/agent/.pi-packages.txt
COPY --chown=agent:agent web-search.json /home/agent/web-search.json
COPY --chown=agent:agent mcp.json /home/agent/mcp.json
COPY --chown=agent:agent APPEND_SYSTEM.md /home/agent/APPEND_SYSTEM.md

# Pre-install pi packages listed in pi-packages.txt so they're baked into the image
RUN while IFS= read -r pkg || [ -n "$pkg" ]; do \
    [ -z "$pkg" ] && continue; \
    echo "Installing pi package: $pkg"; \
    pi install "$pkg"; \
  done < /home/agent/.pi-packages.txt

ENV PLANNOTATOR_REMOTE=1
ENV PLANNOTATOR_PORT=1414
