REM 파일 복사
robocopy ..\obsidian-bingfam\ content\ /xd .obsidian .git template private /mir

REM github에 파일 올리기
npx quartz sync