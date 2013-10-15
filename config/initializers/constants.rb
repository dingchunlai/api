ZHUANQU_BOARD = ["", "装修", "装饰", "产品", "行业", "品牌", "城市", "家居生活"]

TIMESTAMP = Time.now.to_i.to_s
# 不和谐词汇在redis中的key
BAD_WORDS_KEY = "bad_words"  #全局

DECO_CASE_NAME_BAD_WORDS_KEY = "deco_case_name_bad_words" #案例

PINGLUN_ID = 77

HUIFU_ID = 88

ZHUANQU_BOARD_SPELL = ["tag", "d", "deco", "prod", "news", "b", "d", "case"]

PINLEI = ["youqituliao", "diban", "cizhuan", "buyi", "jiajuchanpin", "jiadian", "zhaomingpindao", "cainuan",
  "chuguipindao", "weiyupindao", "kongtiao", "shuichuli"]

DIANXING = ["chufang", "weiyu", "keting", "woshi", "shufang", "huayuanshenghuo", "beijingqiang", "ertongfang",
  "xiaohuxing", "ershoufang", "chaojizhufu", "bieshu"]

JUSHANG = "jushang"

PINPAIKU = "pinpaiku"

ZHUANGXIU = "zhuangxiu" 

#FANXINTAG = 42335 #本地

FANXINTAG = 42397 #测试服务器

#FANXINTAG = 42411 #正式数据

IMAGE_URL = "http://img.51hejia.com"

DECO_DESAGE = "----,1年,2-3年,3-5年,5-8年,8年以上".split(",")
