FROM clojure:temurin-17-tools-deps-1.11.1.1273-bullseye-slim

RUN apt-get update && \
    apt-get install -y curl jq && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get purge --auto-remove && \
    apt-get clean

RUN npm install -g nbb@1.2.173

WORKDIR /opt/test-runner

COPY deps.edn .
RUN clojure -Aoutdated

COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
