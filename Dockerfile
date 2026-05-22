
# # Build for dev
# docker build --build-arg ENV=sandbox -t newsroom-ui:sandbox .

# # Build for qa
# docker build --build-arg ENV=qa -t newsroom-ui:qa .

# # Build for prod
# docker build --build-arg ENV=prod -t newsroom-ui:prod .

# ---- Builder Stage ----
FROM public.ecr.aws/docker/library/node:23-alpine AS builder

WORKDIR /app

ARG ENV=dev
ENV NODE_ENV=dev

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy all source
COPY . .

# Build your app with environment awareness
RUN npm run build:dev


# ---- Final Stage (Nginx) ----
FROM public.ecr.aws/nginx/nginx:1.25-alpine

ARG ENV=dev
ENV APP_ENV=dev

# Replace default nginx.conf with env-based template
COPY nginx.conf /etc/nginx/nginx.conf

# Install dependencies: envsubst (gettext), jq, aws-cli
RUN apk add --no-cache gettext jq aws-cli bind-tools

COPY --from=builder /app/dist-dev/sample-service-ui/. /usr/share/nginx/html/

# Add and configure entrypoint
COPY bin/docker-entrypoint /bin/docker-entrypoint
RUN chmod +x /bin/docker-entrypoint

ENTRYPOINT ["/bin/docker-entrypoint"]