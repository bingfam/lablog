REM 파일 복사
robocopy ..\obsidian-vault\ content\ /xd .obsidian .git template /mir

REM github에 파일 올리기
npx quartz sync