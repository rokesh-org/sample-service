FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install system dependencies
RUN dnf update -y && \
    dnf install -y shadow-utils ruby ruby-devel rubygems gcc gcc-c++ make \
    libffi-devel libyaml-devel zlib-devel openssl-devel readline-devel \
    nodejs20 nodejs20-npm sqlite sqlite-devel findutils && \
    dnf clean all

# Create appuser
RUN groupadd -r appuser && useradd -r -g appuser -m appuser

# Set working directory
WORKDIR /app

# Install Rails gem
RUN gem install rails --no-document

# Scaffold a new Rails app (API-like, minimal)
RUN rails new . --skip-git --skip-bundle --force --minimal

# Copy application files over the scaffold
COPY --chown=appuser:appuser app/ app/
COPY --chown=appuser:appuser config/routes.rb config/routes.rb

# Install gems
RUN bundle install

# Fix ownership
RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
