FROM registry.scicore.unibas.ch/schwede/openstructure as builder
WORKDIR /app/
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common unzip && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install -y python3.8 python3-pip python3.8-dev python3.8-venv
RUN python3.8 -m venv /venv
ENV PATH=/venv/bin:$PATH
RUN pip3 install --upgrade pip
# Download ARES codes
RUN wget https://zenodo.org/records/5090151/files/e3nn_ares.zip https://zenodo.org/records/6893040/files/ares_release.zip && \
	unzip e3nn_ares && \
	unzip ares_release && rm *.zip && \
	mkdir -p lib/ares && \
	mv e3nn_ares ares_release lib/ares/
COPY requirements.txt .
COPY post_requirements.txt .
RUN pip3 install -r requirements.txt
RUN pip3 install -r post_requirements.txt
RUN pip3 install torch-scatter==2.0.5 -f https://pytorch-geometric.com/whl/torch-1.5.0+cu102.html


FROM registry.scicore.unibas.ch/schwede/openstructure as release
WORKDIR /app/
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install -y python3.8 python3-pip python3.8-dev python3.8-venv
RUN python3.8 -m venv /venv
ENV PATH=/venv/bin:$PATH
COPY --from=builder /venv /venv
COPY --from=builder /app/lib/ares /app/lib/ares
RUN pip3 install -e lib/ares/e3nn_ares
COPY . .
ENTRYPOINT [ "/bin/sh", "-c", "bash" ]