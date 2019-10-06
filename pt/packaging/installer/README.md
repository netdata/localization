# Installation

Netdata é um  **agente de monitoramento**. É projetado para ser instalado e rodar em todos os seus sistemas: servidores **físicos** e **virtuais**, **containers**, e até mesmo **IoT** (Internet das coisas).

A melhor maneira de instalar o Netdata é diretamente pelo código-fonte. Nosso **instalador automático** irá instalar qualquer pacote necessário e compilar o Netdata diretamente no seu sistema.

!!! Aviso
    Você pode encontrar os pacotes do Netdata distribuídos por terceiros. Em muitos casos, esses pacotes podem ser antigos ou está quebrados. Portanto, as maneiras sugeridas para instalar o Netdata estão descritas nessa página.

1.  [Instalação automática de uma linha](#one-line-installation), instalação fácil a partir do código-fonte, **modo padrão**
2.  [Instalação do binário estático pré-construído em qualquer Linux 64 bits](#linux-64bit-pre-built-static-binary)
3.  [Executando Netdata em um container docker](#run-netdata-in-a-docker-container)
4.  [Instalação manual, passo-a-passo](#install-netdata-on-linux-manually)
5.  [Instalação no FreeBSD](#freebsd)
6.  [Instalação no pfSense](#pfsense)
7.  [Habilitando no FreeNAS Corral](#freenas)
8.  [Instalação no macOS (OS X)](#macos)
9.  [Instalação em um cluster Kubernetes](https://github.com/netdata/helmchart#netdata-helm-chart-for-kubernetes-deployments)
10. [Instalação usando pacotes binários](#binary-packages)

Veja também a lista dos [mantenedores dos pacotes](../maintainers) para ASUSTOR NAS, OpenWRT, ReadyNAS, etc.

Nota: A partir do Netdata v1.12, informaações anônimas de uso são coletadas por padrão e são enviadas ao Google Analytics. Para ler mais sobre quais informações são coletadas e como optar por não participar, acesse a [página de estatística anônima](../../docs/anonymous-statistics.md).

---

## Instalação automática de uma linha

![](https://registry.my-netdata.io/api/v1/badge.svg?chart=web_log_nginx.requests_per_url&options=unaligned&dimensions=kickstart&group=sum&after=-3600&label=last+hour&units=installations&value_color=orange&precision=0) ![](https://registry.my-netdata.io/api/v1/badge.svg?chart=web_log_nginx.requests_per_url&options=unaligned&dimensions=kickstart&group=sum&after=-86400&label=today&units=installations&precision=0)

Esse método é This method is **totalmente automático em todas as distribuições Linux**. FreeBSD e MacOS precisam de algumas preparações antes de instalar o Netdata pela primeira vez. Veja as seções [FreeBSD](#freebsd) e [MacOS](#macos) para mais informações.

Para instalar o Netdata a partir do código-fonte, e mantê-lo atualizado com nossas **nightly releases** automaticamente, execute os seguntes passos:

```bash
bash <(curl -Ss https://my-netdata.io/kickstart.sh)
```

!!! nota
    Não use `sudo` para o instalador automático de uma linha, ele escalará privilégios, se necessário.

```
Para aprender mais sobre os pós e contras das releases *noturnas* vs *estáveis*, veja nossa [nota sobre as duas opções](#nightly-vs-stable-releases).
```

<details markdown="1"><summary> Clique aqui para mais informações e uso avançado do script de instalação de uma linha.</summary>

Verifique a integridade do script com esse comando:

```bash
[ "735e9966a4cf0187863e06a5282b34a7" = "$(curl -Ss https://my-netdata.io/kickstart.sh | md5sum | cut -d ' ' -f 1)" ] && echo "OK, VALID" || echo "FAILED, INVALID"
```

_Deverá imprimir a mensagem `OK, VALID` se o script for o que enviamos._

O script `kickstart.sh`:

-   detecta a distribuição Linux e **instala os pacotes de sistemas necessários** para construir o Netdata (esse passo pedirá confirmação)
-   baixa o código da última versão do Netdata para `/usr/src/netdata.git`.
-   instala o Netdata executando `./netdata-installer.sh` do código baixado.
-   instala `netdata-updater.sh` para `cron.daily`, assim sua instalação do netdata será atualizada diariamente (você receberá uma mensagem do cron apenas se a atualização falhar).
-   Para  fins de controle de qualidade (QA), esse método de instalação nos informa se o processo foi bem-sucedido ou se falhou.

O script `kickstart.sh` passa todos seus parâmetros para `netdata-installer.sh`, dessa maneira você pode adicionar mais parâmetros para customizar sua instalação. Aqui estão alguns parâmetros importantes:

-   `--dont-wait`: Habilita instalações automatizadas, não solicitando permissões para instalar quaisquer pacotes necessários.
-   `--dont-start-it`: Impede que o instalador inicie o Netdata automaticamente.
-   `--stable-channel`: Atualiza automaticamente somente no lançamento de novas versões principais.
-   `--no-updates`: Previne atualizações automáricas de qualquer tipo.
-   `--local-files`: Usado para instalações offline. Passe quatro caminhos de arquivo: o tarball do Netdata, o checksum, o tarball do plugin go.d e o tarball de configuração do plugin go.d, para forçar o kickstart a executar o processo usando esses arquivos.

Exemplo utilizando todos os parâmetros acima:

```bash
bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait --dont-start-it --no-updates --stable-channel --local-files /tmp/my-selfdownloaded-tarball.tar.gz /tmp/checksums.txt /tmp/manually.downloaded.go.d.binary.tar.gz /tmp/manually.downloaded.go.d.config.tar.gz
```
Nota: `--stable-channel` e `--local-files` se sobrepõem, se você utilizar a opção com tarball, a opção stable-channel não será eficaz
</details>

Uma vez que o Netdata está instalado, veja [Começando](../../docs/getting-started.md).

---

## Binário estatico pré-construido para Linux 64bit

![](https://registry.my-netdata.io/api/v1/badge.svg?chart=web_log_nginx.requests_per_url&options=unaligned&dimensions=kickstart64&group=sum&after=-3600&label=last+hour&units=installations&value_color=orange&precision=0) ![](https://registry.my-netdata.io/api/v1/badge.svg?chart=web_log_nginx.requests_per_url&options=unaligned&dimensions=kickstart64&group=sum&after=-86400&label=today&units=installations&precision=0)

Você pode instalar um binário estático pré-compilado do Netdata em qualquer sistema Linux Intel/AMD 64 bits (mesmo aqueles que não tem um gerenciador de pacotes, como CoreOS, CirrOS, sistemas baseados em busybox, etc). Você também pode utilizar esses pacotes em sistemas como gerenciadores de pacotes não suportados ou quebrados.

Para instalar o Netdata a partir de um pacote binário em qualquer distribuição Linux e qualquer versão de kernel em sistemas **Intel/AMD 64bit**, e mantê-lo atualizado com nossas **nightly releases** automaticamente, execute o seguinte comando:

```bash
bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh)
```

!!! Nota
    Não use `sudo` para esse instalador — ele escalará privilégios, se necessário.

```
Para aprender mais sobre os pós e contras das releases *noturnas* vs *estáveis*, veja nossa [nota sobre as duas opções](#nightly-vs-stable-releases).

Se seu sistema não possui o `bash` instalado, acesse `Mais informações e uso avançado do script kickstart-static64.sh` para instruções de como rodar o instalador sem `bash`.

O script instala o Netdata em `/opt/netdata`.
```

<details markdown="1"><summary>Clique aqui para mais informações e uso avançado desse comando.</summary>

Verifique a integridade do script com o comando abaixo:

```bash
[ "c529e4eb7ce201845cef605d450f8380" = "$(curl -Ss https://my-netdata.io/kickstart-static64.sh | md5sum | cut -d ' ' -f 1)" ] && echo "OK, VALID" || echo "FAILED, INVALID"
```

*Deverá imprimir a mensagem `OK, VALID` se o script for o que enviamos.*

O script `kickstart-static64.sh` passa todos seus parâmetros para `netdata-installer.sh`, dessa maneira você pode adicionar mais parâmetros para personalizar sua instalação. Abaixo estão alguns parâmetros importantes:

-   `--dont-wait`: Habilita instalações automatizadas, não solicitando permissões para instalar quaisquer pacotes necessários.
-   `--dont-start-it`: Impede que o instalador inicie o Netdata automaticamente.
-   `--stable-channel`: Atualiza automaticamente somente no lançamento de novas versões principais.
-   `--no-updates`: Previne atualizações automáricas de qualquer tipo.
-   `--local-files`: Usado para instalações offline. Passe dois caminhos de arquivo: o tarball e o checsum do arquivo, para forçar o kickstart a executar o processo usando esses arquivos.

Exemplo utilizando todos os parâmetros acima:

```sh
bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh) --dont-wait --dont-start-it --no-updates --stable-channel --local-files /tmp/my-selfdownloaded-tarball.tar.gz /tmp/checksums.txt
```
Nota: `--stable-channel` e `--local-files` se sobrepõem, se você utilizar a opção com tarball, a opção stable-channel não será eficaz

Se o seu shell falhar em executar o comando da linha acima, faça:

```sh
# download the script with curl
curl https://my-netdata.io/kickstart-static64.sh >/tmp/kickstart-static64.sh

# or, download the script with wget
wget -O /tmp/kickstart-static64.sh https://my-netdata.io/kickstart-static64.sh

# run the downloaded script (any sh is fine, no need for bash)
sh /tmp/kickstart-static64.sh
```

-   Os arquivos binários estáticos são mantidos no repositório [binary-packages](https://github.com/netdata/binary-packages). Você pode baixar qualquer um dos arquivos `.run` e executá-los. Esses arquivos são shell scripts auto-extraíveis construídos com [makeself](https://github.com/megastep/makeself).
-   O sistema alvo **não** precisa ter o bash instalado.
-   Os mesmos arquivos também podem ser utilizados para atualizações.
-   Para  fins de controle de qualidade (QA), esse método de instalação nos informa se o processo foi bem-sucedido ou se falhou.

</details>

Uma vez que o Netdata está instalado, veja [Começando](../../docs/getting-started.md).

---

## Executando o Netdata em um container Docker

Você pode [Instalar o Netdata com Docker](../docker/#install-netdata-with-docker).

---

## Instalando o Netdata manualmente no Linux

Para instalar a ultima versão do Netdata do git, por favor, siga esses 2 passos:

1.  [Preparando o seu sistema](#prepare-your-system)

    Instale os pacotes necessários no seu sistema.

2.  [Instalando o Netdata](#install-netdata)

    Baixe e installe o Netdata. Você também pode atualizá-lo do mesmo modo.

---

### Preparando o seu sistema

Tente nosso instalador experimental automático de pacotes necessários (não precisa ser root). Ele tentará encontrar os pacotes que devem ser instalados em seu sistema para construir e executar o Netdata. Ele suporta a maioria das distribuições Linux lançadas após 2010:

-   **Alpine** Linux e seus derivados
    -   Você precisa instalar o `bash`, antes de usar o instalador.

-   **Arch** Linux e seus derivados
    -   Você precisa do arch/aur para o pacote Judy.

-   **Gentoo** Linux e seus derivados

-   **Debian** Linux e seus derivados (incluindo o **Ubuntu**, **Mint**)

-   **Redhat Enterprise Linux** e seus derivados (incluindo o **Fedora**, **CentOS**, **Amazon Machine Image**)
    -   Por favor, veja que para RHEL/CentOS você precisa
        [EPEL](http://www.tecmint.com/how-to-enable-epel-repository-for-rhel-centos-6-5/).
        Além disso, a versão 6 do RHEL/CentOS também precisa
        [OKay](https://okay.com.mx/blog-news/rpm-repositories-for-centos-6-and-7.html) para empacotar a versão q do libuv.

-   **SuSe** Linux e seus derivados (incluindo o **openSuSe**)

-   **SLE12** Deve ter seus sistema registrado com o Suse Customer Center ou possuir o DVD. Veja [#1162](https://github.com/netdata/netdata/issues/1162)

Instalar os pacotes para ter uma **instalação básica do Netdata** (monitoramento do sistema e muitas aplicações, sem  `mysql` / `mariadb`, `postgres`, `named`, sensores de hardware e `SNMP`):

```sh
curl -Ss 'https://raw.githubusercontent.com/netdata/netdata-demo-site/master/install-required-packages.sh' >/tmp/kickstart.sh && bash /tmp/kickstart.sh -i netdata
```

Instalar todos os pacotes necessários para **monitorar tudo que o Netdata pode monitorar**:

```sh
curl -Ss 'https://raw.githubusercontent.com/netdata/netdata-demo-site/master/install-required-packages.sh' >/tmp/kickstart.sh && bash /tmp/kickstart.sh -i netdata-all
```

Se o comando acima não funcionar pra você, por favor, [abra uma issue no github](https://github.com/netdata/netdata/issues/new?title=packages%20installer%20failed&labels=installation%20help&body=The%20experimental%20packages%20installer%20failed.%0A%0AThis%20is%20what%20it%20says:%0A%0A%60%60%60txt%0A%0Aplease%20paste%20your%20screen%20here%0A%0A%60%60%60) com uma cópia da mensagem exibida na tela. Estamos tentando fazê-lo funcionar em qualquer lugar (isso é um dos motivos para o script [reportar](https://github.com/netdata/netdata/issues/2054) sucesso ou falha para todas as suas execuções).

---

É assim que se faz manualmente:

```sh
# Debian / Ubuntu
apt-get install zlib1g-dev uuid-dev libuv1-dev liblz4-dev libjudy-dev libssl-dev libmnl-dev gcc make git autoconf autoconf-archive autogen automake pkg-config curl python

# Fedora
dnf install zlib-devel libuuid-devel libuv-devel lz4-devel Judy-devel openssl-devel libmnl-devel gcc make git autoconf autoconf-archive autogen automake pkgconfig curl findutils python

# CentOS / Red Hat Enterprise Linux
yum install autoconf automake curl gcc git libmnl-devel libuuid-devel openssl-devel libuv-devel lz4-devel Judy-devel make nc pkgconfig python zlib-devel

# openSUSE
zypper install zlib-devel libuuid-devel libuv-devel liblz4-devel judy-devel libopenssl-devel libmnl-devel gcc make git autoconf autoconf-archive autogen automake pkgconfig curl findutils python
```

Uma vez que o Netdata compilou, para executá-lo, os seguintes pacotes são necessários (já instalados usando os comandos acima):

| pacotes   | descrição|
|:-----:|-----------|
| `libuuid` | parte do `util-linux` para gerenciamento de GUIDs|
| `zlib`    | compresssão gzip para o servidor web interno do Netdata|

*Netdata falhará ao iniciar sem os pacotes acimas.*

Os plugins do Netdata plugins e vários aspectos do Netdata podem ser ativados ou se beneficiar quando instalados (são opcionais):

| package |description|
|:-----:|-----------|
| `bash`|para plugins do shell e **alarmes de notificação**|
| `curl`|para plugins do shell e **alarmes de notificação**|
| `iproute` or `iproute2`| para monitoramento do **tráfego QoS do Linux**<br/>use `iproute2` se `iproute` mostrar como não disponível ou obsoleto|
| `python`|para maioria dos plugins externos|
| `python-yaml`|usado para monitorar **beanstalkd**|
| `python-beanstalkc`|usado para monitorar **beanstalkd**|
| `python-dnspython`|usado para monitorar DNS query time|
| `python-ipaddress`|usado para monitorar **DHCPd**<br/>esse pacote é necessário apenas se o sistema tiver python v2. python v3 tem essa funcionalidade embarcada|
| `python-mysqldb`<br/>ou<br/>`python-pymysql`|usado para monitorar o banco de dados **mysql** ou **mariadb**<br/>`python-mysqldb` é  rápido e, portando, preferido|
| `python-psycopg2`|usado para monitorar o banco de dados **postgresql**|
| `python-pymongo`|usado para monitorar o banco de dados **mongodb**|
| `nodejs`|usado para os plugins `node.js` para monitorar dispositivos **named** e **SNMP**|
| `lm-sensors`|para monitorar os **sensores de hardware**|
| `libmnl`|para coletar metricas do netfilter|
| `netcat`|for plugins do shell coletar métricas de sistemas remotos|

*O Netdata se beneficiará muito se você tiver os pacotes acima instalados, mas ainda funcionará sem eles.*

As engines de banco de dados do Netdata podem ser ativados quando os pacotes abaixo estão instalados (opcionais):

| package  | description|
|:-----:|-----------|
| `libuv`  | Biblioteca de suporte multiplataforma com foco em I/O assíncrono, versão 1 ou superior|
| `liblz4` | Algoritmo de compactação extremamente rápido, versão r129 ou superior|
| `Judy`   | Matriz dinâmica de uso geral|
| `openssl`| Kit de ferramentas de criptografia e SSL/TLS|

*O Netdata se beneficiará muito se você tiver os pacotes acima instalados, mas ainda funcionará sem eles.*

---

### Instalando o Netdata

Siga os passos abaixo para instalar e executar o Netdata:

```sh
# download it - the directory 'netdata' will be created
git clone https://github.com/netdata/netdata.git --depth=100
cd netdata

# run script with root privileges to build, install, start Netdata
./netdata-installer.sh
```

-   Se você não quer executá-lo imediatamente, adicione a opção `--dont-start-it`.

-   Você pode adicionar também `--stable-channel` para buscar e instalar apenas os lançamentos oficiais do GitHub, em vez das versões noturnas.

-   Se você não quiser instalá-lo nos diretórios padrão, poderá executar o instalador da seguinte maneira: `./netdata-installer.sh --install /opt`. Isso irá instalar o Netdata em `/opt/netdata`.

-   Se o seu servidor não tiver acesso à Internet e você definir manualmente o diretório de instalação no servidor, será necessário passar a opção `--disable-go` para o instalador. A opção impedirá que o instalador tente baixar e instalar o `go.d.plugin`.

Depois que o instalador terminar, o arquivo `/etc/netdata/netdata.conf` será criado se você trocou o diretório de instalação, a configuração aparecerá também nesse diretório).

Voce pode editar esse arquivo para definir as opções. Uma opção comum para ajustar é `history`, que controla o tamanho da memória do banco de dados que o Netdata utilizará. O valor padrão é `3600` segundos ( uma hora de dadosno gráfico) que faz com que o Netdata use cerca de 10-15MB de RAM (dependendo do número de gráficos detectados no seus sistema). Veja **\[[Requisistos de Memória]]**.

Para aplicar as mudanças realizadas, reinicie o Netdata.

---

### Pacotes Binários

![](https://raw.githubusercontent.com/netdata/netdata/master/web/gui/images/packaging-beta-tag.svg?sanitize=true)

Fornecemos nosso próprio flavor de pacotes binários para os sistemas operacionais mais comuns que estão em conformidade com os formatos de pacote .RPM e .DEB.

No momento, lançamos pacotes seguindo o formato .RPM com a versão [1.16.0] (https://github.com/netdata/netdata/releases/tag/v1.16.0).
Planejamos lançar pacotes seguindo o formato .DEB com a versão [1.17.0] (https://github.com/netdata/netdata/releases/tag/v1.17.0).
Pioneiros podem experimentar nossos pacotes .DEB usando nossos lançamentos noturnos. Nosso atual provedor de infraestrutura de empacotamento é o [Package Cloud] (https://packagecloud.io).

O Netdata está comprometida em oferecer suporte à instalação de nossa solução em todos os sistemas operacionais. Essa é uma batalha constante para o Netdata, pois nos esforçamos para automatizar e facilitar as coisas para nossos usuários. Para a matriz de suporte do sistema operacional, visite nossa página de suporte de  [distribuições](../../packaging/DISTRIBUTIONS.md).

Oferecemos dois repositórios separados, um para os lançamentos estáveis e outro para os lançamentos noturnos.

1.  Lançamentos estáveis: Nossas versões estáveis de produção são hospedadas no repositório [netdata/netdata](https://packagecloud.io/netdata/netdata) do package cloud
2.  Lançamentos noturnos: Nossas últimas versões são hospedadas no repositório [netdata/netdata-edge](https://packagecloud.io/netdata/netdata-edge) do package cloud

Visite as páginas dos repositórios e sigam as instruções de configuração rápida para começar.

---

## Outros Sistemas

##### FreeBSD

Você pode instalar o Netdata a partir da coleção de pacotes ou ports.

Abaixo, como instalar a versão mais recente do Netdata a partir de fontes no FreeBSD:

```sh
# install required packages
pkg install bash e2fsprogs-libuuid git curl autoconf automake pkgconf pidof

# download Netdata
git clone https://github.com/netdata/netdata.git --depth=100

# install Netdata in /opt/netdata
cd netdata
./netdata-installer.sh --install /opt
```

##### pfSense

Para installar o Netdata no pfSense, execute os seguintes comandos (dentre de um shell ou sobre o prompt de **Diagnósticos/Comando** dentro da interface web do pfSense).

Note que os primeiros 4 pacotes são baixados do repositório do pfSense para manter a compatibilidade com o pfSense, Netdata e Python que são baixados do repositório FreeBSD.

```sh
pkg install pkgconf
pkg install bash
pkg install e2fsprogs-libuuid
pkg install libuv
pkg add http://pkg.freebsd.org/FreeBSD:11:amd64/latest/All/python36-3.6.9.txz
pkg add http://pkg.freebsd.org/FreeBSD:11:amd64/latest/All/netdata-1.15.0.txz
```
**Nota:** Se você receber um erro de `Not Found` durante a execução dos dois ultimos comandos acima, você precisará procurar manualmente na [pasta do repositório](http://pkg.freebsd.org/FreeBSD:11:amd64/latest/All/) pela últimas versões disponíveis dos pacotes e utilizar suas URL, ou poderá tentar mudar manualmente a versão do netdata na URL da última versão.

Você deve editar `/usr/local/etc/netdata/netdata.conf` e trocar `bind to = 127.0.0.1` para `bind to = 0.0.0.0`.

Para iniciar manualmente o Netdata, execute `service netdata onestart`  

Visite o painel de controle do Netdata para confirmar se está tudo funcionando: `http://<pfsenseIP>:19999`

Para iniciar automaticamente o Netdata a cada boot, adicione `service netdata onestart` como uma entrada de comando do Shell dentro da interface web do pfSense em **Serviços/Shellcmd**. Você precisará instalar o pacote Shellcmd antecipadamente em **System/Package Manager/Available Packages**. O tipo Shellcmd deve ser definido como `Shellcmd`.
![](https://i.imgur.com/wcKiPe1.png)
Alternativamente, mais informações podem ser encontradas em <https://doc.pfsense.org/index.php/Installing_FreeBSD_Packages>, para obter a mesma linha de comando e scripts.

Se você tiver problema com o `/usr/bin/install` ausente no pfSense 2.3 ou anterior, atualize o pfSense ou use uma solução alternativa de <https://redmine.pfsense.org/issues/6643>  

**Nota:** No pfSense, os arquivos de configuração do Netdata estão localizados em `/usr/local/etc/netdata`

##### FreeNAS

No FreeNAS-Corral-RELEASE (>=10.0.3), Netdata está pre-instalado.

Para usar o Netdata, o serviço precisa ser habilitado e iniciado na **[CLI](https://github.com/freenas/cli)** do FreeNAS.

Para ativar o serviço do Netdata:

```sh
service netdata config set enable=true
```

Para iniciar o serviço do Netdata:

```sh
service netdata start
```

##### macOS

O Netdata no macOS ainda possui gráficos limitados, mas plugins externos funcionam.

Você pode instalar o Netdata com o [Homebrew](https://brew.sh/)

```sh
brew install netdata
```

ou pela fonte:

```sh
# install Xcode Command Line Tools
xcode-select --install
```

pressione `Install` na janela de atualização do software, então

```sh
# install HomeBrew package manager
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install required packages
brew install ossp-uuid autoconf automake pkg-config

# download Netdata
git clone https://github.com/netdata/netdata.git --depth=100

# install Netdata in /usr/local/netdata
cd netdata
sudo ./netdata-installer.sh --install /usr/local
```

O instalador também instalará uma lista de inicialização para iniciar o Netdata quando seu Mac iniciar.

##### Alpine 3.x

Execute os comandos abaixo no Alpine Linux 3.x:

```sh
# install required packages
apk add alpine-sdk bash curl zlib-dev util-linux-dev libmnl-dev gcc make git autoconf automake pkgconfig python logrotate

# if you plan to run node.js Netdata plugins
apk add nodejs

# download Netdata - the directory 'netdata' will be created
git clone https://github.com/netdata/netdata.git --depth=100
cd netdata


# build it, install it, start it
./netdata-installer.sh


# make Netdata start at boot
echo -e "#!/usr/bin/env bash\n/usr/sbin/netdata" >/etc/local.d/netdata.start
chmod 755 /etc/local.d/netdata.start

# make Netdata stop at shutdown
echo -e "#!/usr/bin/env bash\nkillall netdata" >/etc/local.d/netdata.stop
chmod 755 /etc/local.d/netdata.stop

# enable the local service to start automatically
rc-update add local
```

##### Synology

A documentação anteriormente recomendava a instalação do pacote Debian Chroot a partir das fontes do pacote da comunidade Synology e a execução do Netdata de dentro do chroot. Isso não funciona, pois o ambiente chroot não tem acesso ao `/ proc` e, portanto, expõe muito poucas métricas ao Netdata. Além disso, [esta issue](https://github.com/SynoCommunity/spksrc/issues/2758), ainda aberta em 24/06/2018, indica que o pacote Debian Chroot não é adequado para versões DSM maiores que a versão 5 e pode corromper as bibliotecas do sistema e impossibilitar a inicialização do NAS.

A boa notícia é que o instalador estático de 64-bit funciona bem se seu NAS é um que utiliza a arquitetura amd64. Ele instalará o conteúdo em `/opt/netdata`, tornando a remoção simples e segura.

Quando o Netdata é instalado pela primeira vez, ele será executado como *root*. Isso pode ou não ser aceitável para você e, como outras instalações o executam como o usuário *netdata*, você pode fazer o mesmo. Isso requer algum trabalho extra:

1.  Crie um grupo `netdata` via interface de grupo do Synology. Não o dê acesso a nada.
2.  Crie um usuário `netdata` via interface de usuário do Synology. Não o dê acesso a nada e defina uma senha aleatória. Atribua o usuário ao grupo `netdata`. O Netdata será enviado a esse usuário durande a execução.
3.  Altere a propriedade dos seguintes diretórios, conforme definido em [Segurança do Netdata](../../docs/netdata-security.md#security-design):

```sh
chown -R root:netdata /opt/netdata/usr/share/netdata
chown -R netdata:netdata /opt/netdata/var/lib/netdata /opt/netdata/var/cache/netdata
chown -R netdata:root /opt/netdata/var/log/netdata
```

Além disso, a partir de 24/06/2018, o instalador do Netdata não reconhece o DSM como um sistema operacional; portanto, nenhum init script é instalado. Você precisará fazer isso manualmente:

1.  Adicione [esse arquivo](https://gist.github.com/oskapt/055d474d7bfef32c49469c1b53e8225f) como `/etc/rc.netdata`. Torne-o executável com `chmod 0755 /etc/rc.netdata`.
2.  Edite `/etc/rc.local` e adicione uma linha chamada `/etc/rc.netdata` para iniciá-lo no boot:

```
# Netdata startup
[ -x /etc/rc.netdata ] && /etc/rc.netdata start
```

## Lançamentos Noturnos vs. Estáveis

A equipe do Netdata mantêm duas versões do agente do Netdata: **noturnos** and **estáveis**. Por padrão, os scripts de instalação do Netdata fornecerão atualizações **automáticas noturnas**, pois essa é a nossa configuração recomendada.

**Noturnos**: Criamos builds noturnas a cada 24 horas. Elas contêm código amplamente testado que corige bugs ou falhas de segurança, ou introduzem novos recursos ao Netdata. Todo lançamento noturno é um candidato para se tornar um lançamento estável; quando estiver pronto, simplesmente alteramos as tags de lançamento no GitHub. Isso significa que as versões noturnas são estáveis e comprovadamente funcionam corretamente na grande maioria dos casos de uso do Netdata. É por isso que a versão noturna é a *melhor opção para a maioria dos usuários de Netdata*.

**Estáveis**: Criamos versões estáveis sempre que acreditamos que o código atingiu um marco importante. Na maioria das vezes, versões estáveis se correlacionam com a introdução de novos recursos significativos. Versões estáveis podem ser uma escolha melhor para aqueles que executam o Netdata em *sistemas de produção de missão crítica*, pois as atualizações ocorrerão com menos frequência e somente depois que a comunidade ajudar a corrigir os bugs que possam ter sido introduzidos nas versões anteriores.

**Vantagens de usar as versões noturnas:**

-   Obtenha os recursos e correções mais recentes assim que estiverem disponíveis
-   Receba correções relacionadas à segurança imediatamente
-   Use código estável e totalmente testado que está sempre melhorando
-   Aproveite a mesma experiência Netdata que nossa comunidade está usando

**Vantagens de usar as versões estáveis:**

-   Proteja-se do raro caso em que grandes bugs passam por nossos testes e afetam negativamente uma instalação do Netdata
-   Mantenha mais controle sobre a versão Netdata usada

## Instalações Offline

Você pode instalar o Netdata em sistemas sem acesso à Internet, mas é necessário executar algumas etapas extras para fazê-lo funcionar.

Por padrão, o `kickstart.sh` e o` kickstart-static64.sh` baixam os ativos do Netdata, como o binário pré-compilado e algumas dependências, usando a conexão com a Internet do sistema, mas você também pode fornecer esses arquivos do sistema de arquivos local.

Primeiro, baixe os arquivos necessários. Se você estiver usando o `kickstart.sh`, precisará do tarball do Netdata, do checksum, do binário do plug-in go.d e da configuração do plug-in go.d. Se você estiver usando o `kickstart-static64.sh`, precisará apenas do tarball e soma de verificação do Netdata.

Faça o download dos arquivos necessários para um sistema que esteja conectado à Internet. Você pode usar os comandos abaixo ou visitar a [última versão do Netdata](https://github.com/netdata/netdata/releases/latest) e a [última página do release go.d plugin](https://github.com/netdata/go.d.plugin/releases) para baixar os arquivos necessários manualmente.

#### kickstart.sh
```bash
cd /tmp

curl -s https://my-netdata.io/kickstart.sh > kickstart.sh

# Netdata tarball
curl -s https://api.github.com/repos/netdata/netdata/releases/latest | grep "browser_download_url.*tar.gz" | cut -d '"' -f 4 | wget -qi -

# Netdata checksums
curl -s https://api.github.com/repos/netdata/netdata/releases/latest | grep "browser_download_url.*txt" | cut -d '"' -f 4 | wget -qi -

# Netdata dependency handling script
curl -s https://raw.githubusercontent.com/netdata/netdata-demo-site/master/install-required-packages.sh | wget -qi -

# go.d plugin
# For binaries for OS types and architectures not listed on [go.d releases](https://github.com/netdata/go.d.plugin/releases/latest), kindly open a github issue and we will do our best to serve your request
export OS=$(uname -s | tr '[:upper:]' '[:lower:]') ARCH=$(uname -m | sed -e 's/i386/386/g' -e 's/i686/386/g' -e 's/x86_64/amd64/g' -e 's/aarch64/arm64/g' -e 's/armv64/arm64/g' -e 's/armv6l/arm/g' -e 's/armv7l/arm/g' -e 's/armv5tel/arm/g') && curl -s https://api.github.com/repos/netdata/go.d.plugin/releases/latest | grep "browser_download_url.*${OS}-${ARCH}.tar.gz" | cut -d '"' -f 4 | wget -qi -

# go.d configuration
curl -s https://api.github.com/repos/netdata/go.d.plugin/releases/latest | grep "browser_download_url.*config.tar.gz" | cut -d '"' -f 4 | wget -qi -
```

#### kickstart-static64.sh
```bash
cd /tmp

curl -s https://my-netdata.io/kickstart-static64.sh > kickstart-static64.sh

# Netdata static64 tarball
curl -s https://api.github.com/repos/netdata/netdata/releases/latest | grep "browser_download_url.*gz.run" | cut -d '"' -f 4 | wget -qi -

# Netdata checksums
curl -s https://api.github.com/repos/netdata/netdata/releases/latest | grep "browser_download_url.*txt" | cut -d '"' -f 4 | wget -qi -
```

Mova os arquivos baixados para o diretório `/tmp` no sistema offline da maneira que sua política definida permitir (se houver alguma).

Agora você pode executar os scripts `kickstart.sh` ou` kickstart-static64.sh` usando a opção `--local-files`. Esta opção requer que você especifique o local e os nomes dos arquivos que você acabou de baixar.

!!! Nota: Quando usar `--local-files`, os scripts `kickstart.sh` ou `kickstart-static64.sh` não irá baixar nenhum arquivo do Netdata da internet. Mas, ainda assim, você pode precisar de uma conexão de internet para instalar dependêcias usando o gerenciador de pacotes do seu sistema. Os scripts irão avisar se seu sistema não possui todas as dependências.

```bash
# kickstart.sh
bash kickstart.sh --local-files /tmp/netdata-version-number-here.tar.gz /tmp/sha256sums.txt /tmp/go.d-binary-filename.tar.gz /tmp/config.tar.gz /tmp/install-required-packages.sh

# kickstart-static64.sh
bash kickstart-static64.sh --local-files /tmp/netdata-version-number-here.gz.run /tmp/sha256sums.txt
```

Agora que você terminou sua instalação offline, pode seguir para o nosso [guia de primeiros passos](../../docs/getting-started.md)!

## Atualizações automáticas

Por padrão, os scripts de instalação do Netdata permitem atualizações automáticas para os canais de versões noturnos e estáveis.

Se você preferir atualizar manualmente o seu agente Netdata, poderá desativar as atualizações automáticas usando a opção `--no-updates` ao instalar ou atualizar o Netdata usando o [script de instalação de uma linha](#one-line-installation).

```bash
bash <(curl -Ss https://my-netdata.io/kickstart.sh) --no-updates
```

Com as atualizações desabilitadas, você poderá escolher exatamente quando e como você irá [atualizar o Netdata](UPDATE.md).

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Finstaller%2FREADME&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)](<>)
