---
title: Quartz4
draft: false
---

#SSG 중에 최고인듯.

## 장점
- #backlink 바로 지원
- #tag 바로 지원
- 한글 검색됨
- github pages action에서 한 번에 처리할 수 있도록 준비되어 있어 편함.

## 설치
https://quartz.jzhao.xyz/ 를 보고 함. 하지만 많이 다름.

![](20251108041703.png)

내 아이디로 로그인 한 다음, 

https://github.com/jackyzha0/quartz

에 접속한다. 여기서 'use this template' 버튼을 눌러 'Create a new repository' 를 선택한다.

그럼 내 계정에 마치 fork 하듯이 이 레포지토리가 그대로 복사된다. fork와의 차이는 저 프로젝트에 기여할 맘이 없다는 점이다. 그냥 복사해서 내가 쓰겠다는 거. clone하고 remote 다시 잡는 거보다 훨씬 편하다.

![[Pasted image 20251108130149.png]]
레포지토리 이름은 내 마음대로 줄 수 있다. 나는 `lablog` 로 정해줬다.

```
cd lablog
npm i
npx quartz create
```

이렇게 하면 설치는 끝난다.


## title 설정

quartz.config.ts 파일에서 pagetitle 부분을 원하는 이름으로 바꿔준다.  

```
pageTitle: "lablog",
```

![[Pasted image 20251108144432.png]]  

이걸 바꿔야 타이틀 부분이 바뀐다.


## 실행

laglog 폴더에서 다음 코드를 실행하면 웹브라우저에서 실행해서 확인할 수 있다.
```
npx quartz build --serve
```
## 글쓰기

content 폴더에 폴더를 만들거나 md 파일을 만들면 그대로 구조로 반영된다.  
SUMMARY.MD 파일을 쓸 일이 없다. 훨씬 편하네.


## github에 올리기

### workflow 설정

`.github\workflows` 폴더 안에 yaml 파일이 4개 있는데 모두 확장자를 yaml_ 로 변경해서 무력화한다.

그리고 deploy.yml 파일을 하나 만들어 다음 내용을 입력한다.  
이 파일은 https://quartz.jzhao.xyz/hosting 에서 가져왔다.

```yaml
name: Deploy Quartz site to GitHub Pages

on:
  push:
    branches:
      - v4

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0 # Fetch all history for git info
      - uses: actions/setup-node@v4
        with:
          node-version: 22
      - name: Install Dependencies
        run: npm ci
      - name: Build Quartz
        run: npx quartz build
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: public

  deploy:
    needs: build
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### 업로드
```
npx quartz sync --no-pull
```

`--no-pull` 은 pull 하지 말라는 옵션이다.
lablog 폴더에서 실행한다.

![[Pasted image 20251108144950.png]]  

github에 push 한 다음 actions에 들어가면 build 하는 상황을 볼 수 있다.


## 옵시디언과의 연계

[[옵시디언]]에서 만든 자료를 그대로 github pages 에 올리려면 #옵시디언 의 vault 폴더를 그대로 quartz의 content 폴더에 복사해야 한다. 

인터넷에서 찾아 보면 vault 폴더를 content 폴더에 symbolic link를 걸어 사용하는 걸 볼 수 있는데, 그건 로컬 pc에서 빌드해서 올리도록 할 때 그렇게 하는 거. 

혹시나 symbolic link 만드는 법은 lablog 폴더에서 `mklink /D content ..\obsidian-vault` 이다.

### ssg를 로컬 pc에서 빌드해서 올리지 않는 이유

가끔 git에서 pull하지 않은 상태에서 빌드하는 경우가 있는데 이렇게 되면 엄청난 conflict를 경험하게 된다. 이거 해결하려면 상당히 귀찮아진다. 그래서 나는 build는 전부 github action에 맡기기로 했다. 

### 옵시디언 파일 가져와 동기화하기

quartz 프로젝트를 template로 새로 만든 프로젝트인 lablog 프로젝트를 clone 한 곳에서 src.bat 파일을 만들어 파일 복사와 github push까지 완료하도록 했다.

**src.bat 파일**
```
REM 파일 복사
robocopy ..\obsidian-vault\ content\ /xd .obsidian .git template /mir
  
REM github에 파일 올리기
npx quartz sync
```

[robocopy](https://learn.microsoft.com/ko-kr/windows-server/administration/windows-commands/robocopy)를 사용해서 동기화 함.   

/mir 옵션을 사용했기 때문에 앞에 적은 `..\obsidian-vault` 폴더의 내용을 그대로 `content` 폴더에 덮어쓴다. 

/xd 옵션은 이 폴더는 제외하라는 뜻이다. 웹에 올릴 필요가 없는 3개의 폴더는 제외한다.
- .obsidian
- .git
- template

옵시디언에서 글을 다 쓴 다음, 이걸 github pages에 올리려면 

src.bat 파일을 실행한다. 


## 태그 문제

글 중에 `#태그` 식으로 글을 쓰면 이게 github pages에서 문제가 생긴다.  

`#태그` 식으로 글을 쓰면, 이 태그가, github pages에서 볼 때 글 위에 태그 목록이 나타나고, 글 중간에도 `#태그` 식으로 보여준다.  

위에 보여지는 태그 목록은 클릭하면 태그 목록을 보여지는 등 잘 동작하는데, 글 중간의 태그는 링크가 잘못 걸려있다. 예를 들면, 

user.github.io/project/tags/obsidian 식으로 태그를 보여주는 링크가 걸려야 하는데, 프로젝트 이름이 빠진  
user.github.io/tags/obsidian 식으로 링크가 걸린다. 

이에 대한 해결 방법은 개발자가 https://quartz.jzhao.xyz/configuration 에 설명해 놓았는데,  

quartz.config.ts 파일에서 baseUrl을 수정하라 한다.  

![[Pasted image 20251108150404.png]]  

그런데 이거 해결이 안 된다. 태그에는 적용되지 않는 듯

quartz.config.ts 파일 내에 아래 부분도 수정했는데 안되고 있음.

``` typescript
analytics: {
      provider: "plausible",
      host: "stuousk.github.io/lablog"
    },
```
