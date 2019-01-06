FROM python:3-alpine
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app
COPY requirements.txt /usr/src/app
RUN apk add --no-cache --virtual .build-deps \
    gfortran \
    g++ \
    openblas-dev
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install \
    --no-cache-dir \
    -r requirements.txt

RUN apk del .build-deps
RUN apk add --no-cache --virtual .build-deps \
    openblas-dev
EXPOSE 8080
ENTRYPOINT ["python3"]
CMD ["-m", "swagger_server"]