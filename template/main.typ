#import "../template.typ": *
#import "../template.typ": template as jsu-thesis

#show: jsu-thesis.with(
  zh_title: "中文论文题目",
  zh_keywords: ("关键词1", "关键词2", "关键词3"),
  zh_abstract: [
    摘要是论文的内容不加注释和评论的简短陈述。
  ],

  en_title: "English Title",
  en_keywords: ("Keyword 1", "Keyword 2", "Keyword 3"),
  en_abstract: [
    This is the English abstract.
  ],

  college: [XX学院],   // 学院名称
  class: [XX班],          // 班级
  author: [XX],               // 姓名
  number: [XXXX],             // 学号
  instructor: [XX],           // 指导教师姓名
  post: [XX],                 // 指导教师职称
  year: [20XX],
  month: [X],
)

#heading(numbering: none)[引言]

= 绪论

在此撰写绪论内容。

= 正文

== 这是二级标题

=== 这是三级标题

正文内容。

== 插入图片

#img(
  image("figures/logo.png", width: 20%),
  caption: [江苏大学logo],
)

=== 插入表格

#tbl(
  table(
    columns: (1fr, 1fr),
    align: center + horizon,
    stroke: none,
    table.hline(stroke: 1.5pt),
    table.header()[*示例*][*示例*],
    table.hline(stroke: 0.8pt),
    [示例], [示例],
    [示例], [示例],
    table.hline(stroke: 1.5pt),
  ),
  caption: [三线表样例],
)

=== 公式

#equation(
  $
    max {F({t_1},{t_2})} = sum^3_(i=1) sum^5_(j=1) T(i,j) dot x_(i j)
  $
)

= 结论

在此撰写结论。

#heading(numbering: none)[参考文献]

#bibliography("refs.bib", style: "gb-7714-2015-numeric", title: none)

#heading(numbering: none)[致谢]

在此撰写致谢。

#heading(numbering: none)[附录]

附录（可选）主要包括一些不宜放在正文中的支撑材料。
