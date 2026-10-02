# check=skip=FromPlatformFlagConstDisallowed
# Pinned Twelf toolchain for checking the proofs in this repository.
#
# Builds Twelf from source (github.com/standardml/twelf, pinned by commit;
# its newest release tag, v1.7.1, dates from 2011, while main has later fixes)
# with MLton on a digest-pinned Ubuntu 24.04 image, so the checker can never
# change underneath the proofs. The image holds only the toolchain; the
# repository is mounted at /workdir and checked by check.sh.
#
# MLton has no Linux arm64 build, so the image is always linux/amd64 (on Apple
# Silicon, Docker Desktop runs it under emulation).
#
# Check all proofs:
#   docker build --platform linux/amd64 -t twelf-tutorial .
#   docker run --rm --platform linux/amd64 -v "$PWD":/workdir twelf-tutorial
FROM --platform=linux/amd64 ubuntu:24.04@sha256:224a1869083a311ef3f13648a154ba79832fbef6364d31493642ca03082da254

ARG TWELF_COMMIT=4224d07cf7a32f69321fd0878043e84539163ee0

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl git make mlton libgmp-dev \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/standardml/twelf.git /opt/twelf \
 && git -C /opt/twelf checkout --quiet "$TWELF_COMMIT" \
 && make -C /opt/twelf mlton \
 && ln -s /opt/twelf/bin/twelf-server /usr/local/bin/twelf-server

WORKDIR /workdir
CMD ["./check.sh"]
