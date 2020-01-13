# 시작 가이드

Netdata를 사용해 주셔서 감사합니다! 이 가이드에선 당신이 Netdata를 설치한 후 처음 해야할 일을 빠르게 안내합니다.

Netdata는 별 다른 설정 없이 실시간으로 수천여개의 측정치를 수집할 수 있지만 필요에 따라 Netdata를 최대한 활용하기 위해 알아야 할 몇 가지 중요한 사항이 있습니다.

> 아직 Netdata를 설치하기 전이라면, 대부분의 Linux 배포판에서 Netdata를 자동으로 설치시켜주는 One-line 스크립트와 세부 지침을 [설치 지침](../packaging/installer)에서 확인하세요.

## 대쉬보드에 접속

웹 브라우저을 열어 `http://YOUR-HOST:19999`에 접속하십시오. Netdata에 오신 것을 환영합니다!

![대쉬보드로 가기 위한 움직이는 gif](https://user-images.githubusercontent.com/1153921/63463901-fcb9c800-c412-11e9-8f67-8fe182e8b0d2.gif)

**이후에 해야할 것은?**: 

-   [standard Netdata dashboard](../web/gui/) 에 대하여 더 읽어보십시오.
-   [charts 사용](../web/README.md#using-charts)에 대한 모든 세부사항이나 [charts와 context, families](../web/README.md#charts-contexts-families)의 차이점에 대해 알아보십시오.

## 설정 기초

Netdata는 설정을 변경하기 위해 주로 `netdata.conf` 파일을 사용합니다.

대부분의 운영체제에서 `netdata.conf` 파일은  `/etc/netdata/netdata.conf`에서 찾을 수 있습니다.

> 일부 운영체제에선 `/etc/netdata/netdata.conf`에 `netdata.conf` 파일이 존재하지 않을 수 있습니다. 그럴 경우 `/opt/netdata/etc/netdata/netdata.conf`에서 찾아보십시오.

`netdata.conf`파일은 `[global]`, `[web]`, `[registry]`등과 같은 다양한 섹션으로 나뉩니다. 기본값으로 대부분의 옵션이 주석처리 되어있습니다. 변경 사항을 적용시키기 위해 (`#`를 제거하여) 주석 처리를 해제해야합니다.

변경 사항을 저장한 후 [restart Netdata](#start-stop-and-restart-netdata)로 새로운 설정을 불러오십시오.

**이후에 해야할 것은?**:

-   `history` 옵션을 증가시키거나 데이터베이스 엔진으로 전환하여 [Netdata가 측정치를 저장하는 기간을 변경하십시오.](#change-how-long-netdata-stores-metrics) 
-   Netdata의 대쉬보드를 [다른 포트](https://docs.netdata.cloud/web/server/)로 이동시키거나 TLS/HTTPS 암호화를 활성화 시키십시오.
-   [daemon configuration documentation](../daemon/config/)에서 `netdata.conf`의 모든 옵션을 확인하십시오.
-   당신의 [registry](../registry/README.md#run-your-own-registry)를 실행시키십시오.

## 더 많은 소스에서 데이터 수집

Netdata가 _시작될 때_ 프로그램은 데이터베이스 서버나 웹 서버 등과 같은 수십개의 **데이터 소스**를 자동 감지합니다. 방금 설치한 서비스나 응용 프로그램에서 측정치를 수집하거나 자동 감지 하기위해 [Netdata를 재시작](#start-stop-and-restart-netdata)해야합니다.

> 한가지 예외가 있습니다! : Netdata가 (컨테이너 자체가 아닌) 호스트에서 실행 중인 경우에는 항상 컨테이너와 VM을 자동 감지할 것 입니다. 

그러나 표준 설치 절차를 따라 소스를 설치한 경우에만 자동 감지가 작동합니다. 재시작 후 Netdata가 측정치를 수집하지 않는다면 당신의 소스는 아마 올바르게 설정되지 않았을 수 있습니다. [외부 플러그인 문서](../collectors/plugins.d/) 에서 당신의 소스에 적당한 모듈을 찾으세요. 해당 문서에는 자동 감지를 위해 소스를 설정하는 방법에 대해 자세한 정보를 포함하고있습니다.

`chrony`같은 일부 모듈은 기본값으로 비활성화되어 있습니다. 자동 감지를 동작시키기 위해 수동으로 활성화 시켜야 합니다.

Netdata가 유효한 데이터 소스를 감지하면 감지한 소스에서 계속 데이터를 수집하려고 시도합니다. 예를 들어 Netdata가 Nginx 웹 서버에서 데이터를 수집하고 있을 때 당신이 Nginx를 종료시키면 Netdata는 당신이 Nginx를 다시 동작시켰을 때 Netdata를 재시작하지 않아도 새로운 데이터를 수집합니다.

### 플러그인 설정

Netdata가 서비스/응용 프로그램을 자동 감지하더라도, Netdata가 어떤 데이터를 얼마나 자주 수집할 지 설정할 수 있습니다.

Netdata는 **내부**, **외부**플러그인을 사용하여 데이터를 수집합니다. 내부 플러그인은 Netdata daemon과 함께 작동합니다. 반면 외부 플러그인은 파이프를 통해 Netdata에 측정치를 보내는 독립적인 프로세스입니다. 하나 이상의 데이터 수집 **모듈**이 있는 외부 플러그인인 **오케스트레이터**도 있습니다.

개별 모듈과 함께 내, 외부 플러그인을 설정할 수 있습니다. 설정을 위한 다음과 같은 방법이 있습니다.


-   `netdata.conf`의 `[plugins]` 섹션 : `yes` or `no`로 내, 외부 플러그인을 활성화/비활성화 시키십시오.
-   `netdata.conf`의 `[plugin:XXX]` 섹션 : 각 플러그인에는 수집 빈도수를 변경하거나 플러그인에 옵션을 전달하는 섹션이 있습니다.
-   각 외부 플러그인의 `.conf` 파일 : `/etc/netdata/python.d.conf`에서 예시를 참고하세요.
-   각 모듈의 `.conf` 파일 : `/etc/netdata/python.d/nginx.conf`에서 예시를 참고하세요.

It's complex, so let's walk through an example of the various `.conf` files responsible for collecting data from an Nginx web server using the `nginx` module and the `python.d` plugin orchestrator.

이 과정은 복잡하기 때문에 `nginx` 모듈과 `python.d` 플러그인 오케스트레이터를 사용하여 Nginx 웹서버

먼저 `netdata.conf`에서 `python.d` 플러그인을 전부 활성화/비활성화 할 수 있습니다.

```conf
[plugins]
    # Enabled
    python.d = yes
    # Disabled
    python.d = no
```

`netdata.conf`파일의 `[plugin:python.d]` 섹션에서도 `python.d` 외부 플러그인을 설정할 수 있습니다. 여기서 측정치를 수집하거나 다른 커맨드 옵션을 전달하기 위해 Netdata가 `python.d`를 사용하는 빈도를 변경할 수 있습니다.

```conf
[plugin:python.d]
    update every = 1
    command options = 
```
`python.d` 플러그인은  `/etc/netdata/python.d.conf`에 위치한 분리된 설정 파일에서 모듈을 활성화/비활성화 할 수 있습니다. `edit-config` 스크립트를 사용하여 파일을 편집하거나 텍스트 에디터로 파일을 열 수 있습니다.

```bash
sudo /etc/netdata/edit-config python.d.conf
```

마지막으로 `nginx` 모듈은 `python.d`폴더에 `nginx.conf`라는 설정 파일을 가지고 있습니다. 마찬가지로 `edit-config`를 사용하거나 텍스트 에디터로 파일을 열 수 있습니다.

```bash
sudo /etc/netdata/edit-config python.d/nginx.conf
```

`nginx.conf` 파일에 추가적인 옵션이 존재합니다. 기본값은 대부분의 상황에서 동작하지만 특정 Nginx 설정에 따라 값을 변경해야할 수 있습니다. 

**이후에 해야할 것은?**:

-   자동 감지와 모니터링을 위한 소스를 설정하기 위해 [data collection modules의 모든 리스트](Add-more-charts-to-netdata.md#available-data-collection-modules)를 확인하십시오.
-   저 메모리 시스템에서의 Netdata의 [performance](Performance.md)을 향상시키십시오.
-   [systemd services utilization](../collectors/cgroups.plugin/README.md#monitoring-systemd-services) 측정치를 자동적으로 드러내기 위해 `systemd`를 설정하십시오.
-   `netdata.conf`의 [개별 차트를 재구성](../daemon/config/README.md#per-chart-configuration)하십시오.

## 상태 모니터링 및 경보

Netdata는 프로덕션 서버(실제로 서비스를 운용중인 서버)의 이상 상태를 감지하기 위해 수백가지의 상태 모니터링 경보가 제공됩니다. 워크스테이션에서 실행되는 Netdata의 경우 Netdata 경보를 비활성화 할 수 있습니다.
Netdata on a workstation, you might want to disable Netdata's alarms.

`/etc/netdata/netdata.conf`을 열어 아래를 따라 설정하세요.

```conf
[health]
    enabled = no
```

상태 모니터링을 활성화한 상태에서 이메일 알림만 끄고 싶다면 `edit-config`를 사용하거나 텍스트 에디터를 사용해 `health_alarm_notify.conf`를 편집하세요.

```bash
sudo /etc/netdata/edit-config health_alarm_notify.conf
```

`SEND_EMAIL="YES"` 라인을 찾아 `SEND_EMAIL="NO"`로 바꾸면 됩니다.

**이후에 해야할 것은?**:

-   [health quickstart](../health/QUICKSTART.md)를 따라 기존의 상태 entities를 찾아 편집하여 당신의 상태 entities를 만드세요.
-   [health configuration reference](../health/REFERENCE.md)에서 모든 경보 옵션을 확인하세요.
-   [Slack](../health/notifications/slack/)과 같은 새로운 알람 방법을 추가해보세요.

## Netdata가 측정치를 저장하는 기간을 변경

Netedata는 RAM과 디스크를 모두 사용하는 커스텀 데이터베이스를 사용하여 측정치를 저장하도록 기본 값이 설정되어 있습니다. 최신의 측정치는 빠른 접근 속도를 위해 RAM에 저장되고 기록 측정치는 RAM 사용량을 낮추기 위해 디스크에 저장됩니다.

_database engine_ 이라는 이름의 이러한 커스텀 데이터베이스에선 시스템의 가용 RAM보다 더 큰 데이터셋을 저장할 수 있습니다.

당신이 database engine을 사용하고 있는지 확실하지 않거나 기록 측정치를 더 저장하기 위해 기본 설정을 조정하려면 다음의 튜토리얼을 확인하십시오 : [**Changing how long Netdata stores metrics**](../docs/tutorials/longer-metrics-storage.md).

**이후에 해야할 것은?**:

-   [database engine의 메모리 요구 사항](../database/engine/README.md#memory-requirements)을 더 알아보시면 기록 측정치 저장을 위해 얼마나 많은 RAM/디스크 공간을 확보해야 하는지 이해할 수 있습니다.
-   [round-robin database](../database/)의 메모리 요구 사항을 읽어보거나 시스템에 KSM이 활성화되어 있는지 확인하여 약 60% 정도 [기본 데이터베이스의 메모리 사용량을 감소](../database/README.md#ksm)시킬 수 있습니다.

## Netdata로 다중의 시스템 모니터링

Netdata를 다중의 시스템에 설치한 경우, 대시보드의 상단 좌측 코너에 있는 **My nodes** 메뉴에서 모두 표시 할 수 있습니다.

해당 메뉴에서 모든 서버를 표시하기 위해 
To show all your servers in that menu, 각 시스템 마다 [Netdata Cloud](../docs/netdata-cloud/)에 [회원가입이나 로그인](../docs/netdata-cloud/signing-in.md)을 해야합니다. 그러면 각 시스템이 **My nodes** 메뉴에 나타나 당신이 다중의 시스템을 더 빠르게 탐색하도록 사용할 수 있습니다. 

![Animated GIF of the My Nodes menu in
action](https://user-images.githubusercontent.com/1153921/64389938-9aa7b800-cff9-11e9-9653-a77e791811ad.gif)

차트를 이동, 확대, 강조표시, 선택이나 일시 정시 할 때마다 Netdata는 My nodes 메뉴를 통해 당신이 방문한 다른 에이전트와 해당 설정을 동기화합니다. 스크롤 위치 또한 동기화되므로 근본 원인 분석이나 쉬운 비교를 위해 동일한 차트의 각각의 데이터를 확인 할 수 있습니다.

이제 전체 인프라에서 성능 이상을 완벽하게 추적할 수 있습니다.

**이후에 해야할 것은?**:

-   Read up on how the [Netdata Cloud registry works](../registry/), and what kind of data it stores and sends to your web browser.
-   Familiarize yourself with the [Nodes View](../docs/netdata-cloud/nodes-view.md)

## Netdata 시작, 정지, 재시작

Netdata를 설치하면 기본적으로 부팅 시 Netdata가 시작되고, 시스템 종료시 중지, 재시작되도록 설정되어 있습니다. Netdata를 직접 시작하거나 중지할 필요가 없지만 Netdata를 재시작해야할 경우도 있습니다.

-   Netdata를 **start** 하기 위해, 터미널을 켜고 `service netdata start`를 입력하십시오.
-   Netdata를 **stop** 하기 위해, 터미널을 켜고 `service netdata stop`를 입력하십시오.
-   Netdata를 **restart** 하기 위해, 터미널을 켜고 `service netdata restart`를 입력하십시오.

`service` 명령는 시스템 기반의 Netdata를 시작 또는 중지하는 시스템의 기본 방법을 사용하는 래퍼 스크립트입니다. 그러나 이러한 명령 중 하나라도 실패하면 `systemd` 혹은 `init.d` 명령어를 사용해보십시오.

-   **systemd**: `systemctl start netdata`, `systemctl stop netdata`, `systemctl restart netdata`
-   **init.d**: `/etc/init.d/netdata start`, `/etc/init.d/netdata stop`, `/etc/init.d/netdata restart`

## 이후에 해야할 것은?

`netdata.conf` 설정을 마치고, 경보를 수정하고, 성능 상 문제 해결의 기본을 배우고, **My nodes** 메뉴에 모든 시스템을 올리면 본격적으로 Netdata를 시작할 준비를 마쳤습니다.

아래에서 더 고급 기능과 설정을 확인해보세요.

-   [streaming](../streaming)을 이용해 다중의 시스템에서 Netdata 측정치를 중앙 집중화 해보세요.
-   [backends](../backends)을 통해 시계열 데이터베이스에 Netdata 지표를 장기간 저장해보세요.
-   Netdata를 [Nginx proxy with SSL](Running-behind-nginx.md) 뒤에 배치시키면 보안을 향상시킬 수 있습니다.

혹은 [Netdata core](../CONTRIBUTING.md)나 Netdata의 [documentation](../docs/contributing/contributing-documentation.md)!에 기여하는 법을 더 알아보세요!

[![analytics](https://www.google-analytics.com/collect?v=1&aip=1&t=pageview&_s=1&ds=github&dr=https%3A%2F%2Fgithub.com%2Fnetdata%2Fnetdata&dl=https%3A%2F%2Fmy-netdata.io%2Fgithub%2Fdocs%2Fgetting-started&_u=MAC~&cid=5792dfd7-8dc4-476b-af31-da2fdb9f93d2&tid=UA-64295674-3)](<>)