FROM java:8

MAINTAINER Jumpei Matsuda <jmatsu.drm@gmail.com>

ENV DOCKER_CONAINER true
ENV WORKSPACE /workspace
RUN mkdir -p $WORKSPACE

# init locales
ENV LANG en_US.UTF-8
RUN apt-get update && apt-get install -y --reinstall locales && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    localedef --list-archive && locale -a && \
    update-locale en_US.UTF-8

# ready for ruby
RUN apt-get install -y --force-yes --no-install-recommends build-essential curl git zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev

RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv && sleep 1 && git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build && sleep 1 && /root/.rbenv/plugins/ruby-build/install.sh

ENV PATH /root/.rbenv/bin:/root/.rbenv/shims:$PATH
RUN echo "install: --no-document\nupdate: --no-document" > /etc/gemrc

# ready for texlive
RUN apt-get install -y texlive-lang-japanese texlive-fonts-recommended

# init review
ONBUILD COPY ./.ruby-version /.ruby-version
ONBUILD RUN RUBY_VERSION=$(cat /.ruby-version|tr -d "\n") && rbenv install $RUBY_VERSION && rbenv global $RUBY_VERSION
ONBUILD RUN gem install bundler

ONBUILD COPY Gemfile /Gemfile
ONBUILD RUN bundle install

# init redpen
ONBUILD COPY ./redpen-version /.redpen-version
ONBUILD RUN mkdir -p /redpen && \
    REDPEN_VERSION=$(cat /.redpen-version|tr -d "\n") && \
    wget -O /redpen/redpen.tar.gz https://github.com/redpen-cc/redpen/releases/download/redpen-$REDPEN_VERSION/redpen-$REDPEN_VERSION.tar.gz && \
    cd /redpen && \
    tar xvf redpen.tar.gz && \
    mv redpen-* unarchived && \
    mv unarchived/* . && \
    rm -fr redpen.tar.gz

ENV PATH /redpen/bin:$PATH

WORKDIR $WORKSPACE

CMD echo "will be replaced"
