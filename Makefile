E3NN_PATH="https://zenodo.org/records/5090151/files/e3nn_ares.zip"
ARES_PATH="https://zenodo.org/records/6893040/files/ares_release.zip"

download_e3nn:
	wget ${E3NN_PATH} ${ARES_PATH}
	unzip e3nn_ares
	unzip ares_release && rm *.zip
	mkdir -p lib/ares
	mv e3nn_ares ares_release lib/ares/

predict:
	python -m ares_model

docker_multi:
	docker build --rm -t ares_multi --target release .
	docker run -it ares_multi