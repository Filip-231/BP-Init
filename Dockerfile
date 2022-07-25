FROM python:3.9-alpine

ENV PATH="/scripts:${PATH}"

COPY ../templates/django/%7B%7Bcookiecutter.repo_name%7D%7D/requirements.txt /requirements.txt
RUN apk add --update --no-cache --virtual .tmp gcc libc-dev linux-headers
RUN pip install -r /requirements.txt
RUN apk del .tmp

RUN mkdir /structure
COPY ./structure /structure
WORKDIR /structure
COPY scripts /scripts

RUN chmod +x /scripts/*

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN adduser -D user
RUN chown -R user:user /vol
RUN chmod -R 755 /vol/web

RUN chown -R user:user /structure
RUN chmod 755 /structure


USER user

CMD ["entrypoint.sh"]
