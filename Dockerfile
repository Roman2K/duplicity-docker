FROM python:3.9-alpine3.14 AS python-base
RUN addgroup -g 1000 -S app \
  && adduser -u 1000 -S app -G app

##
# Build image
#
FROM python-base
RUN apk add --update build-base gettext librsync-dev
USER app
RUN pip3 install --user --no-warn-script-location duplicity

##
# Runtime image
#
FROM python-base
RUN apk add --update librsync gnupg
WORKDIR /home/app
COPY --from=1 --chown=app:app /home/app/.local .local
USER app
ENV PATH=/home/app/.local/bin:$PATH
ENTRYPOINT ["duplicity"]
