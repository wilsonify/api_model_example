FROM python:3-alpine as base

RUN apk add --no-cache \
        --virtual=.build-dependencies \
        g++ \
        libstdc++ \
        gfortran \
        file \
        binutils \
        gcc \
        make \
        gmp \
        gmp-dev \
        suitesparse \
        suitesparse-dev \
        musl-dev \
        python3-dev \
        openblas \
        openblas-dev

RUN ln -s locale.h /usr/include/xlocale.h


FROM base as builder
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app
COPY requirements.txt /usr/src/app

RUN pip install --no-cache-dir -r requirements.txt && \
    pip install cython && \
    pip install pycddlib && \
    wget "ftp.gnu.org/gnu/glpk/glpk-4.65.tar.gz" && \
    tar xzf "glpk-4.65.tar.gz" && \
    cd "glpk-4.65" && \
    ./configure --disable-static && \
    make -j4 && \
    make install-strip

ENV CVXOPT_BLAS_LIB=openblas
ENV CVXOPT_LAPACK_LIB=openblas
ENV CVXOPT_BUILD_GLPK=1

RUN  pip install \
    --global-option=build_ext \
    --global-option="-I/usr/include/suitesparse" \
      cvxopt

FROM builder as built
RUN find /usr/lib/python3.*/ -name 'tests' -exec rm -r '{}'
RUN find /usr/lib/python3.*/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; && \
    rm /usr/include/xlocale.h && \
    apk del .build-dependencies &&\
    rm -rf /root/.cache && \
    find /usr/lib/python3.*/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; && \
    rm -rf /tmp/*

EXPOSE 8080
ENTRYPOINT ["python3"]
CMD ["-m", "swagger_server"]