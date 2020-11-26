@echo off &setlocal enabledelayedexpansion
cls
set /p original_path=Enter path of your old wallet (.keys file): 
set /p "wallet_pass_original=Enter wallet password:"
if /I "%wallet_pass_original%"=="" goto wallet_no_pass
set "wallet_pass=!wallet_pass_original:&=^&!"
setlocal DisableDelayedExpansion

echo Your password is: %wallet_pass%

set bin_pass=0
copy %original_path% old_wallet.keys
echo @echo off >run_forknote.bat
echo "windows_bin/forknote_simplewallet.exe" --config-file=config/inf.conf --wallet-file=old_wallet.keys --password="%wallet_pass_original%" >>run_forknote.bat
echo exit >>run_forknote.bat
start run_forknote.bat
timeout 15 /nobreak >nul
taskkill /f /im forknote_simplewallet.exe
timeout 1 /nobreak >nul
"windows_bin/bytecoin_walletd.exe" --wallet-file=old_wallet.wallet --export-keys --wallet-password="%wallet_pass_original%"
echo keys exported press any key to exit
pause >nul
del old_wallet.wallet
goto end
:wallet_no_pass
copy %original_path% old_wallet.keys
echo @echo off >run_forknote.bat
echo "windows_bin/forknote_simplewallet.exe" --config-file=config/inf.conf --wallet-file=old_wallet.keys --password "" >>run_forknote.bat
echo exit >>run_forknote.bat
start run_forknote.bat
timeout 15 /nobreak >nul
taskkill /f /im forknote_simplewallet.exe
timeout 1 /nobreak >nul
(echo( & echo ) | "windows_bin/bytecoin_walletd.exe" --wallet-file=old_wallet.wallet --export-keys
echo keys exported press any key to exit
pause >nul
del old_wallet.wallet
:end
exit
