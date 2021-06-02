FROM davidzemon/obex-client as client-builder

FROM davidzemon/obex-server-rust
COPY --from=client-builder /usr/share/nginx/html /opt/client
CMD ["/opt/server/obex-server", "--static-content", "/opt/client"]
