FROM python:3-alpine
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app
ENV PATH=/usr/src/app/venv/bin:$PATH
#COPY requirements.txt /usr/src/app/
#RUN apk add --no-cache --virtual .build-deps \
#    gfortran \
#    musl-dev \
#    g++ \
#    gcc \
#    openblas-dev
#RUN ln -s /usr/include/locale.h /usr/include/xlocale.h
#RUN python3 -m pip install --upgrade pip
#RUN python3 -m pip install --no-cache-dir -r requirements.txt
#RUN apk del .build-deps
EXPOSE 8080
ENTRYPOINT ["python3"]
CMD ["-m", "swagger_server"]


