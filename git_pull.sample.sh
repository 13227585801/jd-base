#!/bin/sh

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LC_ALL=C


################################## 定义是否自动删除失效的脚本与定时任务 ##################################
## 有的时候，某些JS脚本只在特定的时间有效，过了时间就失效了，lxk0301 大佬会在Github Action中删除，但如果是本地任务，则不会自动删除
## 需要自动删除失效的本地定时任务，则设置为 true ，否则请设置为 false
AutoDelCron="true"


################################## 定义是否自动增加新的本地定时任务 ##################################
## lxk0301 大佬会在有需要的时候，增加Github Action定时任务，但如果是本地的定时任务，则不会自动增加
## 如需要自动增加新的本地定时任务，则设置为 true ，否则请设置为 false
## 请注意：如果你设置为 true，本脚本将会自动从 scripts/.github/workflows 文件夹新增加的 .yml 文件中读取 cron 这一行的任务时间
## 但因为Github Action定时任务采用的是UTC时间，比北京时间晚8小时，所以会导致本地任务无法真正地在准确设定的时间运行，需要手动修改crontab
## 两种时区时间对应关系见 https://datetime360.com/cn/utc-beijing-time/ 或 http://www.timebie.com/cn/universalbeijing.php
AutoAddCron="false"


################################## 定义用户数量 ##################################
## 请填入总共有多少个京东用户的账号，这里定义了多少个，在下面定义的Cookie、ForOtherFruit、ForOtherPet、ForOtherPlantBean数量就应当有多少个。
## 比如UserSum为4，那么Cookie、ForOtherFruit、ForOtherPet、ForOtherPlantBean都只有编号1-4的变量生效
UserSum=6


################################## 定义Cookie ##################################
## 请依次填入每个用户的Cookie，Cookie的具体形式：pt_key=xxxxxxxxxx;pt_pin=xxxx;
## 获取Cookie的具体教程：https://github.com/lxk0301/scripts/blob/master/backUp/GetJdCookie.md 或 https://github.com/lxk0301/scripts/blob/master/backUp/GetJdCookie2.md
## UserSum定义了多少个，Cookie就必须输入多少个，按数字顺序1、2、3、4...依次编号下去。
Cookie1=""
Cookie2=""
Cookie3=""
Cookie4=""
Cookie5=""
Cookie6=""


################################## 定义通知TOKEN ##################################
## 想通过什么渠道收取通知，就填入对应渠道的值
## ServerChan，教程：http://sc.ftqq.com/3.version
SCKEY=""

## BARK，BARK_PUSH和BARK_SOUND必须都赋值，教程：https://github.com/lxk0301/scripts/blob/master/githubAction.md
BARK_PUSH=""
BARK_SOUND=""

## Telegram，TG_BOT_TOKEN和TG_USER_ID必须都赋值，教程：https://github.com/lxk0301/scripts/pull/37#issuecomment-692415594
TG_BOT_TOKEN=""
TG_USER_ID=""

## 钉钉，DD_BOT_TOKEN和DD_BOT_SECRET必须都赋值，教程：https://ding-doc.dingtalk.com/doc#/serverapi2/qf2nxq
DD_BOT_TOKEN=""
DD_BOT_SECRET=""


################################## 定义东东农场每个人自己的互助码 ##################################
## 东东农场每个人自己的互助码，可以在运行一次东东农场脚本（jd_fruit）后从日志中查看
## 约定：MyFruit后面的编号为数字的是提供了Cookie的账号所对应的互助码，编号与Cookie编号一一对应，如MyFruit1、MyFruit2
## 约定：MyFruit后面的编号为大写字母的是未提供Cookie的账号所对应的互助码（即想为其他人助力），如MyFruitA、MyFruitB
MyFruit1=""
MyFruit2=""
MyFruit3=""
MyFruit4=""
MyFruit5=""
MyFruit6=""
MyFruitA=""
MyFruitB=""


################################## 定义东东农场要为哪些人助力 ##################################
## 1.每账号一天可助力4次，超出的无法被助力，想要为谁助力，添加上面定义的MyFruit变量就可以
## 2.js脚本要求每个互助码间需要使用@隔开，为保证shell脚本能将@正确传递，需要写作"\@"，包括双引号
## 3.MyFruit系列变量中没有赋值的不能填写在下方，比如：上面未赋值的 MyFruitA；另外，也不能为自己助力
## 4.举例：ForOtherFruit1=${MyFruit2}"\@"${MyFruit3}"\@"${MyFruit4}"\@"${MyFruit6} ，含义是Cookie1的账户将为Cookie2、Cookie3、Cookie4、Cookie6的账户提供助力
## 5.UserSum定义了多少个，ForOtherFruit就只能且必须多少个（从1开始计），超出的无效
## 6.可以不赋值，即不给任何人助力，如：ForOtherFruit2=""
ForOtherFruit1=
ForOtherFruit2=
ForOtherFruit3=
ForOtherFruit4=
ForOtherFruit5=
ForOtherFruit6=


################################## 定义东东萌宠每个人自己的互助码 ##################################
## 东东萌宠每个人自己的互助码，可以在运行一次东东萌宠脚本（jd_pet）后从日志中查看
## 约定：MyPet后面的编号为数字的是提供了Cookie的账号所对应的互助码，编号与Cookie编号一一对应，如MyPet1、MyPet2
## 约定：MyPet后面的编号为大写字母的是未提供Cookie的账号所对应的互助码（即想为其他人助力），如MyPetA、MyPetB
MyPet1=""
MyPet2=""
MyPet3=""
MyPet4=""
MyPet5=""
MyPet6=""
MyPetA=""
MyPetB=""


################################## 定义东东萌宠要为哪些人助力 ##################################
## 1.每账号一天可助力5次，超出的无法被助力，想要为谁助力，添加上面定义的MyPet变量就可以
## 2.js脚本要求每个互助码间需要使用@隔开，为保证shell脚本能将@正确传递，需要写作"\@"，包括双引号
## 3.MyPet系列变量中没有赋值的不能填写在下方，比如：上面未赋值的 MyPetA；另外，也不能为自己助力
## 4.举例：ForOtherPet1=${MyPet2}"\@"${MyPet3}"\@"${MyPet4}"\@"${MyPet5}"\@"${MyPetA} ，含义是Cookie1的账户将为Cookie2、Cookie3、Cookie4、Cookie5的账户以及单独只提供了互助码的A用户提供助力
## 5.UserSum定义了多少个，ForOtherPet就只能且必须多少个（从1开始计），超出的无效
## 6.可以不赋值，即不给任何人助力，如：ForOtherPet1=""
ForOtherPet1=
ForOtherPet2=
ForOtherPet3=
ForOtherPet4=
ForOtherPet5=
ForOtherPet6=


################################## 定义种豆得豆每个人自己的互助码 ##################################
## 种豆得豆每个人自己的互助码，可以在运行一次种豆得豆脚本（jd_plantBean）后从日志中查看
## 约定：MyPlantBean后面的编号为数字的是提供了Cookie的账号所对应的互助码，编号与Cookie编号一一对应，如MyPlantBean1、MyPlantBean2
## 约定：MyPlantBean后面的编号为大写字母的是未提供Cookie的账号所对应的互助码（即想为其他人助力），如MyPlantBeanA、MyPlantBeanB
MyPlantBean1=""
MyPlantBean2=""
MyPlantBean3=""
MyPlantBean4=""
MyPlantBean5=""
MyPlantBean6=""
MyPlantBeanA=""
MyPlantBeanB=""


################################## 定义种豆得豆要为哪些人助力 ##################################
## 1.每账号一天可助力3次，超出的无法被助力，想要为谁助力，添加上面定义的MyPlantBean变量就可以
## 2.js脚本要求每个互助码间需要使用 @ 隔开，为保证 shell 脚本能将 @ 正确传递给 js ，需要写作"\@"，包括双引号
## 3.MyPlantBean系列变量中没有赋值的不能填写在下方，比如：上面未赋值的 MyPlantBeanB；另外，也不能为自己助力
## 4.举例：ForOtherPlantBean1=${MyPlantBean2}"\@"${MyPlantBeanA} ，含义是Cookie1的账户将为Cookie2的账户以及单独只提供了互助码的A用户提供助力
## 5.UserSum定义了多少个，ForOtherPlantBean就只能且必须有多少个（从1开始计），超出的无效
## 6.可以不赋值，即不给任何人助力，如：ForOtherPlantBean5=""
ForOtherPlantBean1=
ForOtherPlantBean2=
ForOtherPlantBean3=
ForOtherPlantBean4=
ForOtherPlantBean5=
ForOtherPlantBean6=


################################## 定义京小超蓝币兑换数量 ##################################
## 京小超蓝币兑换，可用值包括：
## 一、1至20中的一个整数：表示兑换1-20个京豆
## 二、1000：表示兑换1000个京豆
## 三、2801390972：兑换巧白酒精喷雾（目前已下架）
## 四、2801390982：兑换巧白西柚洗手液
## 五、2801390984：兑换雏菊洗衣凝珠
## js脚本默认为0，即为不自动兑换，具体情况请自行在京小超游戏中去查阅
coinToBeans=2801390984


################################## 定义京小超蓝币成功兑换奖品是否静默运行 ##################################
## 默认关闭（即:奖品兑换成功后会发出通知提示），如需要静默运行不发出通知，请改为 true
NotifyBlueCoin=""


################################## 定义京小超是否自动升级商品和货架 ##################################
## 升级顺序：解锁升级商品、升级货架，默认自动升级，如需关闭自动升级，请改为 false
superMarketUpgrade="false"


################################## 定义京小超是否自动更换商圈 ##################################
## 小于对方300热力值自动更换商圈队伍，默认允许自动更换，如不想更换商圈，请改为 false
businessCircleJump=""


################################## 定义东东农场是否静默运行 ##################################
## 默认为 false，不静默，发送推送通知消息，如不想收到通知，请修改为 true
NotifyFruit=""


################################## 定义宠汪汪喂食克数 ##################################
## 你期望的宠汪汪每次喂食克数，只能填入10、20、40、80，默认为10
## 如实际持有食物量小于所设置的克数，js脚本会自动降一档，直到降无可降
## 具体情况请自行在宠汪汪游戏中去查阅攻略
joyFeedCount=20


################################## 定义宠汪汪兑换京豆是否静默运行 ##################################
## 默认为true，静默，不发送推送通知消息，如想要收到通知，请修改为 false
NotifyJoy=""


################################## 定义宠汪汪是否自动给好友的汪汪喂食 ##################################
## 默认为不会自动给好友的汪汪喂食，如想自动喂食，请改成 true
jdJoyHelpFeed=""


################################## 定义宠汪汪是否自动偷好友积分与狗粮 ##################################
## 默认自动偷取，如不想自动偷取，请改成 false
jdJoyStealCoin=""


################################## 定义宠汪汪是否自动报名宠物赛跑 ##################################
## 默认参加宠物赛跑，如需关闭，请改成 false
joyRunFlag=""


################################## 定义文件路径 ##################################
ShellDir=$(cd $(dirname $0); pwd)
RootDir=$(cd $(dirname $0); cd ..; pwd)
LogDir=${RootDir}/log
ScriptsDir=${RootDir}/scripts
ScriptsURL=https://github.com/lxk0301/scripts
ListShell=${LogDir}/shell.list
ListJs=${LogDir}/js.list
ListJsAdd=${LogDir}/js-add.list
ListJsDrop=${LogDir}/js-drop.list
ListCron=${RootDir}/crontab.list


################################## 定义js脚本名称 ##################################
FileCookie=jdCookie.js
FileNotify=sendNotify.js
FileFruitShareCodes=jdFruitShareCodes.js
FilePetShareCodes=jdPetShareCodes.js
FilePlantBeanShareCodes=jdPlantBeanShareCodes.js
FileJoy=jd_joy.js
FileJoyFeed=jd_joy_feedPets.js
FIleJoySteal=joy_steal.js
FileBlueCoin=jd_blueCoin.js
FileSuperMarket=jd_superMarket.js
FileFruit=jd_fruit.js


################################## 在日志中记录时间与路径 ##################################
echo
echo "-------------------------------------------------------------------"
echo
echo -n "当前时间："
echo $(date "+%Y-%m-%d %H:%M:%S")
echo
echo "SHELL脚本目录：${ShellDir}"
echo 
echo "JS脚本目录：${ScriptsDir}"
echo
echo "-------------------------------------------------------------------"
echo


################################## 更新JS脚本 ##################################
function Git_Pull {
  echo "更新JS脚本，原地址：$ScriptsURL"
  echo
  git fetch --all
  git reset --hard origin/master
  git pull
}


################################## 修改JS脚本中的Cookie ##################################
function Change_Cookie {
  CookieALL=""
  echo "${FileCookie}: 替换Cookies..."
  sed -i "/\/\/账号/d" ${FileCookie}
  ii=1
  while [ ${ii} -le $UserSum ]
  do
    Temp1=Cookie${ii}
    eval CookieTemp=$(echo \$${Temp1})
    CookieALL="${CookieALL}\\n'${CookieTemp}',"
    let ii++
  done
  perl -0777 -i -pe "s|let CookieJDs = \[\n\]|let CookieJDs = \[${CookieALL}\n\]|" ${FileCookie}
}


################################## 修改通知TOKEN ##################################
function Change_Token {
  ## ServerChan
  if [ ${SCKEY} ]; then 
    echo "${FileNotify}: 替换ServerChan推送通知SCKEY..."
    sed -i "s|let SCKEY = '';|let SCKEY = '${SCKEY}';|" ${FileNotify}
  fi

  ## BARK
  if [ ${BARK_PUSH} ] && [ ${BARK_SOUND} ]; then 
    echo "${FileNotify}: 替换BARK推送通知BARK_PUSH、BARK_SOUND..."
    sed -i "s|let BARK_PUSH = '';|let BARK_PUSH = '${BARK_PUSH}';|" ${FileNotify}
    sed -i "s|let BARK_SOUND = '';|let BARK_SOUND = '${BARK_SOUND}';|" ${FileNotify}
  fi

  ## Telegram
  if [ ${TG_BOT_TOKEN} ] && [ ${TG_USER_ID} ]; then 
    echo "${FileNotify}: 替换Telegram推送通知TG_BOT_TOKEN、TG_USER_ID..."
    sed -i "s|let TG_BOT_TOKEN = '';|let TG_BOT_TOKEN = '${TG_BOT_TOKEN}';|" ${FileNotify}
    sed -i "s|let TG_USER_ID = '';|let TG_USER_ID = '${TG_USER_ID}';|" ${FileNotify}
  fi

  ## 钉钉
  if [ ${DD_BOT_TOKEN} ] && [ ${DD_BOT_SECRET} ]; then 
    echo "${FileNotify}: 替换钉钉推送通知DD_BOT_TOKEN、DD_BOT_SECRET..."
    sed -i "s|let DD_BOT_TOKEN = '';|let DD_BOT_TOKEN = '${DD_BOT_TOKEN}';|" ${FileNotify}
    sed -i "s|let DD_BOT_SECRET = '';|let DD_BOT_SECRET = '${DD_BOT_SECRET}';|" ${FileNotify}
  fi
}


################################## 替换东东农场互助码 ##################################
function Change_FruitShareCodes {
  ForOtherFruitALL=""
  echo "${FileFruitShareCodes}: 替换东东农场互助码..."
  sed -i "/\/\/账号/d" ${FileFruitShareCodes}
  ij=1
  while [ ${ij} -le $UserSum ]
  do
    Temp2=ForOtherFruit${ij}
    eval ForOtherFruitTemp=$(echo \$${Temp2})
    ForOtherFruitALL="${ForOtherFruitALL}\\n'${ForOtherFruitTemp}',"
    let ij++
  done
  perl -0777 -i -pe "s|let FruitShareCodes = \[\n\]|let FruitShareCodes = \[${ForOtherFruitALL}\n\]|" ${FileFruitShareCodes}
}


################################## 替换东东萌宠互助码 ##################################
function Change_PetShareCodes {
  ForOtherPetALL=""
  echo "${FilePetShareCodes}: 替换东东萌宠互助码..."
  sed -i "/\/\/账号/d" ${FilePetShareCodes}
  ik=1
  while [ ${ik} -le $UserSum ]
  do
    Temp3=ForOtherPet${ik}
    eval ForOtherPetTemp=$(echo \$${Temp3})
    ForOtherPetALL="${ForOtherPetALL}\\n'${ForOtherPetTemp}',"
    let ik++
  done
  perl -0777 -i -pe "s|let PetShareCodes = \[\n\]|let PetShareCodes = \[${ForOtherPetALL}\n\]|" ${FilePetShareCodes}
}


################################## 替换种豆得豆互助码 ##################################
function Change_PlantBeanShareCodes {
  ForOtherPlantBeanALL=""
  echo "${FilePlantBeanShareCodes}: 替换种豆得豆互助码..."
  sed -i "/\/\/账号/d" ${FilePlantBeanShareCodes}
  il=1
  while [ ${il} -le $UserSum ]
  do
    Temp4=ForOtherPlantBean${il}
    eval ForOtherPlantBeanTemp=$(echo \$${Temp4})
    ForOtherPlantBeanALL="${ForOtherPlantBeanALL}\\n'${ForOtherPlantBeanTemp}',"
    let il++
  done
  perl -0777 -i -pe "s|let PlantBeanShareCodes = \[\n\]|let PlantBeanShareCodes = \[${ForOtherPlantBeanALL}\n\]|" ${FilePlantBeanShareCodes}
}


################################## 修改京小超蓝币兑换数量 ##################################
function Change_coinToBeans {
  if [ ${coinToBeans} -gt 1 ] && [ ${coinToBeans} -le 20 ]
  then
    echo "${FileBlueCoin}: 修改京小超蓝币兑换数量为：${coinToBeans}..."
    perl -i -pe "s|0;.+或者1000即可|${coinToBeans};|" ${FileBlueCoin}
  else
    case ${coinToBeans} in
    0)
      echo "${FileBlueCoin}: 京小超蓝币兑换数量保持默认值0，不自动兑换...";;
    2801390972)
      echo "${FileBlueCoin}: 修改京小超蓝币兑换数量为：${coinToBeans}，即兑换巧白酒精喷雾..."
      perl -i -pe "s|0;.+或者1000即可|${coinToBeans};|" ${FileBlueCoin};;
    2801390982)
      echo "${FileBlueCoin}: 修改京小超蓝币兑换数量为：${coinToBeans}，即兑换巧白西柚洗手液..."
      perl -i -pe "s|0;.+或者1000即可|${coinToBeans};|" ${FileBlueCoin};;
    2801390984)
      echo "${FileBlueCoin}: 修改京小超蓝币兑换数量为：${coinToBeans}，即兑换雏菊洗衣凝珠..."
      perl -i -pe "s|0;.+或者1000即可|${coinToBeans};|" ${FileBlueCoin};;
    *)
      echo "${FileBlueCoin}: coinToBeans 输入了错误值，将保持默认值0，不自动兑换...";;
    esac
  fi
}


################################## 修改京小超蓝币成功兑换奖品是否静默运行 ##################################
function Change_NotifyBlueCoin {
  if [ "${NotifyBlueCoin}" = "true" ]
  then
    echo "${FileBlueCoin}：修改京小超成功兑换蓝币是否静默运行：${NotifyBlueCoin}，成功兑换后静默运行不发通知..."
    sed -i "s|let jdNotify = false;|let jdNotify = ${NotifyBlueCoin};|" ${FileBlueCoin}
  else
    echo "${FileBlueCoin}：NotifyBlueCoin保持默认，京小超成功兑换蓝币后将发通知..."
  fi
}


################################## 修改京小超是否自动升级商品和货架 ##################################
function Change_superMarketUpgrade {
  if [ "${superMarketUpgrade}" = "false" ]
  then
    echo "${FileSuperMarket}：修改京小超是否自动升级商品和货架为：${superMarketUpgrade}，不自动升级..."
    sed -i "s|let superMarketUpgrade = true;|let superMarketUpgrade = ${superMarketUpgrade};|" ${FileSuperMarket}
  else
    echo "${FileSuperMarket}：superMarketUpgrade保持默认，京小超将默认自动升级商品和货架..."
  fi
}


################################## 修改京小超是否自动更换商圈 ##################################
function Change_businessCircleJump {
  if [ "${businessCircleJump}" = "false" ]
  then
    echo "${FileSuperMarket}：修改京小超是否自动更换商圈为：${businessCircleJump}"
    sed -i "s|let businessCircleJump = true;|let businessCircleJump = ${businessCircleJump};|" ${FileSuperMarket}
  else
    echo "${FileSuperMarket}：businessCircleJump保持默认，京小超将自动更换商圈.."
  fi
}


################################## 修改东东农场是否静默运行 ##################################
function Change_NotifyFruit {
  if [ "${NotifyFruit}" = "true" ]
  then
    echo "${FileFruit}：修改东东农场是否静默运行为：${NotifyFruit}，静默运行"
    sed -i "s|let jdNotify = false;|let jdNotify = ${NotifyFruit};|" ${FileFruit}
  else
    echo "${FileFruit}：NotifyFruit保持默认，东东农场将不静默运行，将发通知..."
  fi
}


################################## 修改宠汪汪喂食克数 ##################################
function Change_joyFeedCount {
  case ${joyFeedCount} in
    20 | 40 | 80)
      echo "${FileJoy}: 修改宠汪汪喂食克数为：${joyFeedCount}g..."
      echo
      echo "${FileJoyFeed}: 修改宠汪汪喂食克数为：${joyFeedCount}g..."
      perl -i -pe "s|10;.+\[10,20,40,80\]|${joyFeedCount};|" ${FileJoy}
      perl -i -pe "s|10;.+其他数字不可\.|${joyFeedCount};|" ${FileJoyFeed};;
    10)
      echo "${FileJoy}: 宠汪汪喂食克数保持默认值：10g..."
      echo
      echo "${FileJoyFeed}: 宠汪汪喂食克数保持默认值：10g...";;
    *)
      echo "joyFeedCount输入了错误值，不修改宠汪汪喂食克数，保持默认值...";;
  esac
}


################################## 修改宠汪汪兑换京豆是否静默运行 ##################################
function Change_NotifyJoy {
  if [ "${NotifyJoy}" = "false" ]
  then
    echo "${FileJoy}：修改宠汪汪兑换京豆是否静默运行为：${NotifyJoy}，不静默运行，将发通知..."
    sed -i "s|let jdNotify = true;|let jdNotify = ${NotifyJoy};|" ${FileJoy}
  else
    echo "${FileJoy}：NotifyJoy保持默认，宠汪汪兑换京豆将静默运行..."
  fi
}


################################## 修改宠汪汪是否自动报名宠物赛跑 ##################################
function Change_joyRunFlag {
  if [ "${joyRunFlag}" = "false" ]
  then
    echo "${FileJoy}：修改宠汪汪是否自动报名宠物赛跑为：${joyRunFlag}..."
    sed -i "s|let joyRunFlag = true;|let joyRunFlag = ${joyRunFlag};|" ${FileJoy}
  else
    echo "${FileJoy}：joyRunFlag保持默认，宠汪汪将自动报名宠物赛跑..."
  fi
}


################################## 修改宠汪汪是否自动给好友的汪汪喂食 ##################################
function Change_jdJoyHelpFeed {
  if [ "${jdJoyHelpFeed}" = "true" ]
  then
    echo "${FIleJoySteal}：修改宠汪汪自动给好友的汪汪喂食为：${jdJoyHelpFeed}..."
    sed -i "s|let jdJoyHelpFeed = false;|let jdJoyHelpFeed = ${jdJoyHelpFeed};|" ${FIleJoySteal}
  else
    echo "${FIleJoySteal}：jdJoyHelpFeed保持默认，宠汪汪将不会给好友的汪汪喂食..."
  fi
}


################################## 修改宠汪汪是否自动偷好友积分与狗粮 ##################################
function Change_jdJoyStealCoin {
  if [ "${jdJoyStealCoin}" = "false" ]
  then
    echo "${FIleJoySteal}：修改宠汪汪是否自动偷好友积分与狗粮为：${jdJoyStealCoin}..."
    sed -i "s|let jdJoyStealCoin = false;|let jdJoyStealCoin = ${jdJoyStealCoin};|" ${FIleJoySteal}
  else
    echo "${FIleJoySteal}：jdJoyStealCoin保持默认，宠汪汪将会自动偷取好友积分与狗粮..."
  fi
}


################################## 获取git修改状态 ##################################
function Git_Status {
  echo "获取git修改状态如下："
  echo
  git status | grep "modified:" | sed "s/\s//g"
}


################################## 检测Github Action定时任务是否有变化 ##################################
## 此函数会在Log文件夹下生成四个文件，分别为：
## shell.list   shell文件夹下用来跑js文件的以“jd_”开头的所有 .sh 文件清单（去掉后缀.sh）
## js.list      scripts/.github/workflows下所有以“jd_”开头的所有 .yml 文件清单（去掉后缀.yml），这是 lxk0301@github 大佬定义的所有GitHub Action定时任务
## js-add.list  如果 scripts/.github/workflows 增加了定时任务，这个文件内容将不为空
## js-drop.list 如果 scripts/.github/workflows 删除了定时任务，这个文件内容将不为空
function Git_Different {
  if [ ! -f ${ListShell} ]; then 
    ls -l ${ShellDir} | grep -E "jd_.+\.sh" | awk '{print $9}' | sed "s/\.sh//" > ${ListShell}
  fi
  ls -l ${ScriptsDir}/.github/workflows | grep -E "jd_.+\.yml" | awk '{print $9}' | sed "s/\.yml//" > ${ListJs}
  grep -v -f ${ListShell} ${ListJs} > ${ListJsAdd}
  grep -v -f ${ListJs} ${ListShell} > ${ListJsDrop}
}


################################## 依次修改上述设定的值 ##################################
cd ${ScriptsDir}
Git_Pull
GitPullExitStatus=$?
if [ ${GitPullExitStatus} -eq 0 ]
then
  echo
  echo "更新JS脚本完成..."
  echo
  Change_Cookie
  echo
  Change_Token
  echo
  Change_FruitShareCodes
  echo
  Change_PetShareCodes
  echo
  Change_PlantBeanShareCodes
  echo
  Change_coinToBeans
  echo
  Change_NotifyBlueCoin
  echo
  Change_superMarketUpgrade
  echo
  Change_businessCircleJump
  echo
  Change_NotifyFruit
  echo
  Change_joyFeedCount
  echo
  Change_NotifyJoy
  echo
  Change_joyRunFlag
  echo
  Change_jdJoyHelpFeed
  echo
  Change_jdJoyStealCoin
  echo
  Git_Status
  echo
  Git_Different
  
  ## 检测是否有新的定时任务
  if [ -s ${ListJsAdd} ]  
  then
    echo "检测到有新的定时任务："
	cat ${ListJsAdd}
  else
    echo "没有检测到新的定时任务..."
  fi
  echo
  
  ## 检测失效的定时任务  
  if [ -s ${ListJsDrop} ]
  then
    echo "检测到失效的定时任务："
	cat ${ListJsDrop}
  else
    echo "没有检测到失效的定时任务..."
  fi
  echo
  
else
  echo "JS脚本拉取不正常，所有JS文件将保持上一次的状态..."
  echo

fi


################################## 自动删除失效的脚本与定时任务 ##################################
## 如果检测到某个定时任务在https://github.com/lxk0301/scripts中已删除，那么在本地也删除对应的shell脚本与定时任务
## 此功能仅在 AutoDelCron 设置为 true 时生效
if [ ${GitPullExitStatus} -eq 0 ] && [ "${AutoDelCron}" = "true" ] && [ -s ${ListJsDrop} ]; then
  echo "开始尝试自动删除定时任务如下："
  echo
  cat ${ListJsDrop}
  echo
  JsDrop=$(cat ${ListJsDrop})
  for i in ${JsDrop}
  do
	sed -i "/\/$i\.sh/d" ${ListCron}
	rm -f "${ShellDir}/$i.sh"
  done
  crontab ${ListCron}
  echo "成功删除失效的脚本与定时任务，当前的定时任务清单如下："
  echo
  crontab -l
  echo
fi


################################## 自动增加新的定时任务 ##################################
## 如果检测到https://github.com/lxk0301/scripts中增加新的Guthub Action定时任务，那么在本地也增加
## 此功能仅在 AutoDAddCron 设置为 true 时生效
## 本功能生效时，会自动从 scripts/.github/workflows 文件夹新增加的 .yml 文件中读取 cron 这一行的任务时间，
## 但因为Github Action定时任务采用的是UTC时间，比北京时间晚8小时，所以会导致本地任务无法真正地在准确设定的时间运行，需要手动修改crontab
## 两种时区时间对应关系见 https://datetime360.com/cn/utc-beijing-time/ 或 http://www.timebie.com/cn/universalbeijing.php
if [ ${GitPullExitStatus} -eq 0 ] && [ "${AutoAddCron}" = "true" ] && [ -s ${ListJsAdd} ]; then
  echo "开始尝试自动添加定时任务如下："
  echo
  cat ${ListJsAdd}
  echo
  JsAdd=$(cat ${ListJsAdd})
  if [ -f ${ShellDir}/jd.sample.sh ]
  then
	for i in ${JsAdd}
	do
	  cp -fv "${ShellDir}/jd.sample.sh" "${ShellDir}/$i.sh"
	  grep "cron:" "${ScriptsDir}/$i.yml" | sed -E "s/\s+-\s*cron:\s*'//g" | sed "s/'/ ${ShellDir}\/$i\.sh/" >> ${ListCron}
	done
	crontab ${ListCron}
	echo "成功添加新的定时任务，当前的定时任务清单如下："
	echo
	crontab -l
	echo
  else
	echo "${ShellDir}/jd.sample.sh 文件不存在，请先下载..."
    echo
	echo "未能添加新的定时任务，请自行增加..."
    echo
  fi
fi


################################## npm install ##################################
echo "运行npm install"
echo
npm install
echo