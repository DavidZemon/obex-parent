FROM node:lts-slim as client-builder
COPY client/package.json /opt/client/package.json
COPY client/package-lock.json /opt/client/package-lock.json
RUN cd /opt/client && npm install
COPY client /opt/client
RUN cd /opt/client && npm run build -- --prod=true

FROM python:3.8.5-slim
RUN apt-get update \
    && apt-get upgrade --yes \
    && apt-get install --yes --no-install-recommends git-core \
    && rm -rf /var/lib/apt/lists/*
COPY server/requirements.txt /opt/server/requirements.txt
RUN pip install -r /opt/server/requirements.txt
COPY server /opt/server
COPY --from=client-builder /opt/client/dist/obex /opt/client
EXPOSE 8000
ENV OBEX_DEBUG='False' \
    OBEX_STATIC_FILES_ROOT=/opt/client
CMD ["python", "/opt/server/manage.py", "runserver", "0.0.0.0:8000"]
