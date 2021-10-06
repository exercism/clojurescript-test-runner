FROM clojure:openjdk-17-tools-deps-1.10.3.822-slim-buster

RUN apt-get update && \
    apt-get install -y curl jq && \ 
    curl -fsSL https://deb.nodesource.com/setup_15.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get purge --auto-remove && \
    apt-get clean

RUN npm install -g nbb@0.0.92

WORKDIR /opt/test-runner

COPY deps.edn .
RUN clojure -Aoutdated

COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
