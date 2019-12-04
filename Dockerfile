FROM google/dart:2.5

RUN pub global activate aqueduct

ADD . /opt/fias

WORKDIR /opt/fias

RUN pub install

RUN ./apply_patch.sh

ENV PATH /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/root/.pub-cache/bin

EXPOSE 8888

CMD aqueduct serve
