# Clone the MultiMC buildbot git repo
mmc-bbot-image:
  file.recurse:
    - name: /root/mmc-bbmaster
    - source: salt://docker/mmc-bbot/mmc-bbmaster/
    - clean: true
  docker_image.present:
    - name: mmc-bbot
    - build: /root/mmc-bbmaster/
    - tag: latest

mmc-bbot:
  file.managed:
    - name: /etc/systemd/system/mmc-bbot.service
    - source: salt://docker/mmc-bbot/mmc-bbot.service
    - user: root
    - group: root
    - mode: 0644
  service.running:
    - enable: True
    - require:
      - file: mmc-bbot
      - docker_image: mmc-bbot-image
    - watch:
      - file: /root/mmc-bbmaster-data/buildbot.cfg


mmc-bbslave-service:
  file.managed:
    - name: /etc/systemd/system/mmc-bbslave@.service
    - source: salt://docker/mmc-bbot/mmc-bbslave@.service
    - user: root
    - group: root
    - mode: 0644

mmc-env-ubu64:
  file.recurse:
    - name: /root/mmc-env-ubu64
    - source: salt://docker/mmc-bbot/mmc-env-ubu64/
    - clean: true
  docker_image.present:
    - name: forkk/mmc-env-ubu64
    - build: /root/mmc-env-ubu64/
    - tag: latest
    - require:
      - file: mmc-env-ubu64

mmc-bbslave-ubu64:
  file.recurse:
    - name: /root/mmc-bbslave-ubu64
    - source: salt://docker/mmc-bbot/mmc-bbslave-ubu64/
    - clean: true
  docker_image.present:
    - name: forkk/mmc-bbslave-ubu64
    - build: /root/mmc-bbslave-ubu64/
    - tag: latest
    - require:
      - file: mmc-bbslave-ubu64
  service.running:
    - name: mmc-bbslave@ubu64
    - enable: True
    - require:
      - file: mmc-bbslave-service
      - docker_image: mmc-bbslave-ubu64

mmc-bbslave-site:
  file.recurse:
    - name: /root/mmc-bbslave-site
    - source: salt://docker/mmc-bbot/mmc-bbslave-site/
    - clean: true
  docker_image.present:
    - name: forkk/mmc-bbslave-site
    - build: /root/mmc-bbslave-site/
    - tag: latest
    - require:
      - file: mmc-bbslave-site
  service.running:
    - name: mmc-bbslave@site
    - enable: True
    - require:
      - file: mmc-bbslave-service
      - docker_image: mmc-bbslave-site

mmc-bbslave-translator:
  file.recurse:
    - name: /root/mmc-bbslave-translator
    - source: salt://docker/mmc-bbot/mmc-bbslave-translator/
    - clean: true
  docker_image.present:
    - name: forkk/mmc-bbslave-translator
    - build: /root/mmc-bbslave-translator/
    - tag: latest
    - require:
      - file: mmc-bbslave-translator
  service.running:
    - name: mmc-bbslave@translator
    - enable: True
    - require:
      - file: mmc-bbslave-service
      - docker_image: mmc-bbslave-translator

/root/mmc-bbmaster-data/buildbot.cfg:
  file.managed:
    - source: salt://docker/mmc-bbot/master.cfg
    - template: jinja
    - makedirs: true
    - user: root
    - group: root
    - mode: 0600


# Slave info files.

# Boto config for Amazon S3 access
/etc/private/mmc-bbot/boto.cfg:
  file.managed:
    - source: salt://docker/mmc-bbot/boto.cfg
    - template: jinja
    - makedirs: true
    - user: root
    - group: root
    - mode: 0600

# s3cmd config for Amazon S3 access
/etc/private/mmc-bbot/s3cmd.cfg:
  file.managed:
    - source: salt://docker/mmc-bbot/s3cmd.cfg
    - template: jinja
    - makedirs: true
    - user: root
    - group: root
    - mode: 0600

/etc/private/mmc-bbot/passwords.json:
  file.managed:
    - source: salt://docker/mmc-bbot/passwords.json
    - template: jinja
    - makedirs: true
    - user: root
    - group: root
    - mode: 0600

/etc/private/mmc-bbslave-ubu64/info.json:
  file.managed:
    - source: salt://docker/mmc-bbot/ubu64-info.json
    - template: jinja
    - makedirs: true
    - user: root
    - group: root
    - mode: 0600

/etc/private/mmc-bbslave-site/info.json:
  file.managed:
    - source: salt://docker/mmc-bbot/site-info.json
    - template: jinja
    - makedirs: true
    - user: root
    - group: root
    - mode: 0600

/etc/private/mmc-bbslave-translator/info.json:
  file.managed:
    - source: salt://docker/mmc-bbot/translator-info.json
    - template: jinja
    - makedirs: true
    - user: root
    - group: root
    - mode: 0600
