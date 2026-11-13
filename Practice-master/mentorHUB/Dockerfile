FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npx ng build --configuration production --base-href /mentorhub/

FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY nginx-main.conf /etc/nginx/nginx.conf
COPY --from=builder /app/dist/mentorHUB/browser /usr/share/nginx/html

RUN chown -R nginx:nginx /usr/share/nginx/html \
    && touch /tmp/nginx.pid \
    && chown nginx:nginx /tmp/nginx.pid \
    && mkdir -p /tmp/nginx-cache \
    && chown -R nginx:nginx /tmp/nginx-cache

USER nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
