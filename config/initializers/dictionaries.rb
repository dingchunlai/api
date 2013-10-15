MODELS = {
  1 => '清包',
  2 => '半包',
  3 => '全包',
  4 => '纯设计'
}
SHANGHAI_MODELS = {
  1 => '清包',
  2 => '半包',
  3 => '全包',
  4 => '设计工作室',
  5 => '装修监理'
}

STYLES = {
  1 => '现代简约',
  2 => '田园风格',
  3 => '欧美式',
  4 => '中式风格',
  5 => '地中海',
  6 => '混搭'
}

PRICE = {
  1 => '8万以下',
  2 => '8-15万',
  3 => '15-30万',
  4 => '30万-100万',
  5 => '100万以上'
}

SHANGHAI_PRICE = {
  1 => '8万以下',
  2 => '8-15万',
  3 => '15万以上'
}

NINBO_PRICE = [
  [1, '6万以下'],
  [2, '6-10万'],
  [3, '10-15万'],
  [6, '15-30万'],
  [4, '30万以上']
]
  
DISTRICTS = {
  12226=>"嘉定",
  12215=>"金山",
  12221=>"南汇",
  12210=>"卢湾",
  12227=>"普陀",
  12216=>"青浦",
  12222=>"静安",
  12211=>"松江",
  12228=>"徐汇",
  12217=>"宝山", 
  12223=>"奉贤",
  12212=>"浦东",
  12218=>"崇明",
  12224=>"虹口",
  12213=>"闸北",
  12219=>"闵行",
  12225=>"黄浦",
  12214=>"长宁",
  12220=>"杨浦",
  12749=>"上海市区"
}

CITIESIP = {
  0 => '0',
  1 => '11910',
  2 => '12117',
  3 => '12122',
  4 => '12301',
  5 => '12306',
  6 => '12118'
}

# 公司的各种排序规则
COMPANY_SORT_ORDERS = {
  1 => %w[praise              默认],
  2 => %w[design_praise       设计],
  3 => %w[construction_praise 施工],
  4 => %w[service_praise      服务]
}

# 这个ORDERS还有页面在使用，但是那些页面还在不在用就暂时不清楚
ORDERS = {
  1 => ['praise',        '综合'],
  2 => ['adjusted_design_score',  '设计'],
  4 => ['adjusted_service_score', '服务'],
  3 => ['adjusted_construction_score','施工'],
  5 => ['budget_praise', '性价比'],
  6 => ['pv_count', '人气']
}

ROOM = {
  1 => '小户型',
  2 => '两房',
  3 => '三房',
  4 => '四房',
  5 => '复式',
  6 => '别墅'
}

TAGURLS = {
  0 => "",
  0 => "quanguo",
  11910 => "shanghai",
  12117 => "suzhou",
  12122 => "nanjing",
  12301 => "ningbo",
  12306 => "hangzhou",
  12118 => "wuxi"
}

STAGE = {
  9 => '装修准备',
  1 => '风格设计',
  2 => '隐蔽工程',
  8 => '建材选购',
  3 => '泥瓦工程',
  4 => '木工工程',
  5 => '油漆工程',
  6 => '安装收尾',
  7 => '装修完工'
}

BOLG = {
  0 => '业主点评',
  1 => '现场抽查',
  2 => '小编看公司',
  3 => '创作案例'
}

TOP_CONDITION = { #首页排行榜 查询条件
  'pv' => 'pv',
  '设计分' => 'adjusted_design_score',
  '施工分' => 'adjusted_construction_score',
  '服务分' => 'adjusted_service_score'
}

GOOD={
  1 => '好',
  0 => '中',
  -1 => '差'
}
SPACE = {
  1 => '厨房',
  2 => '餐厅',
  3 => '客厅',
  4 => '卫生间',
  5 => '卧室',
  6 => '书房',
  7 => '儿童房',
  8 => '衣帽间',
  9 => '阳台',
  10 => '阁楼',
  11 => '花园',
  12 => '飘窗',
  13 => '储藏室',
  14 => '阳光房',
  15 => '玄关',
  16 => '过道',
  17 => '其他'
}
  
sk = "新闻 行业 资讯,http://www.51hejia.com/xinwen/;" +
  "卖场,http://www.51hejia.com/maichang/;" +
  "博客,http://blog.51hejia.com/;" +
  "装修,http://d.51hejia.com/;" +
  "地板,http://www.51hejia.com/diban/;" +
  "涂料 油漆,http://www.51hejia.com/youqituliao/;" +
  "瓷砖,http://www.51hejia.com/cizhuan/;" +
  "布艺,http://www.51hejia.com/buyi/;" +
  "家具,http://www.51hejia.com/jiajuchanpin/;" +
  "家电,http://www.51hejia.com/jiadian/;" +
  "灯具 灯饰 照明,http://www.51hejia.com/zhaomingpindao/;" +
  "采暖,http://www.51hejia.com/cainuan/;" +
  "厨房橱柜,http://www.51hejia.com/chuguipindao/;" +
  "卫浴用品 卫生间用品 洗手间用品,http://www.51hejia.com/weiyupindao/;" +
  "中央空调,http://www.51hejia.com/kongtiao/;" +
  "水处理,http://www.51hejia.com/shuichuli/;" +
  "装饰 时尚家居,http://www.51hejia.com/jushang/;" +
  "厨房,http://www.51hejia.com/chufang/;" +
  "卫浴 卫生间 洗手间,http://www.51hejia.com/weiyu/;" +
  "客厅,http://www.51hejia.com/keting/;" +
  "卧室,http://www.51hejia.com/woshi/;" +
  "书房,http://www.51hejia.com/shufang/;" +
  "花园,http://www.51hejia.com/huayuanshenghuo/;" +
  "背景墙,http://www.51hejia.com/beijingqiang/;" +
  "儿童房,http://www.51hejia.com/ertongfang/;" +
  "小户型,http://www.51hejia.com/xiaohuxing/;" +
  "二手房,http://www.51hejia.com/ershoufang/;" +
  "主妇,http://www.51hejia.com/chaojizhufu/;" +
  "别墅,http://www.51hejia.com/bieshu/;" +
  "品牌,http://b.51hejia.com/;" +
  "百安居,http://zt.51hejia.com/shanghai/baianj/index.html;"
HASH_KEYWORDS =
  sk.split(";").inject({}) do |hash, entry|
  keys, value = entry.split ','
  keys.split(' ').each { |key| hash[key] = value }
  hash
end

REGISTERS_SEX = {
  1 => '男',
  2 => '女'
}

REGISTERS_VISIT_TIME = {
  1 => '周一至周五',
  2 => '双休日'
}
