# jsu-thesis-template

江苏大学本科毕业设计（论文）Typst 模板 | Typst Template for Jiangsu University Undergraduate Thesis

## 一分钟快速体验

三行命令，立即生成一份完整的示例学位论文 PDF：

```bash
typst init @preview/jsu-thesis-template:0.1.0 my-thesis
cd my-thesis
typst compile main.typ
```

打开 `main.pdf`，即可看到一份包含封面、原创性声明、中英文摘要、目录、正文、参考文献、致谢、附录等全部要素的完整示例论文。这份示例论文同时也是一份用户指南，按论文格式排版，边看边用。之后只需把 `main.typ` 中的示例信息替换成你自己的内容即可开始写作。

## 功能特性

- 封面（校徽 + 校名标 + 中英文题目 + 学院 / 班级 / 姓名 / 学号 / 指导教师 / 职称 / 年月）
- 原创性声明页
- 中文摘要（含关键词）
- 英文摘要（ABSTRACT + KEY WORDS）
- 自动目录（三级标题，点线填充）
- 正文（中文章节编号 第X章 / 1.1 / 1.1.1）
- 页眉页脚自动切换（前置部分罗马数字，正文阿拉伯数字）
- 中英文混排字体方案（宋体 / 黑体 / 楷体 / Times New Roman）
- 图表环境（`img` / `tbl`，自动编号与交叉引用）
- 公式、代码块（Consolas）
- GB/T 7714-2015 参考文献（numeric 样式）
- 致谢、附录
- 全自动字号系统（初号 ~ 小七，中文习惯字号）
- 随包分发字体，跨平台排版一致

## 获取模板

### 方式一：从 Typst Universe 创建（推荐）

```bash
typst init @preview/jsu-thesis-template:0.1.0 my-thesis
cd my-thesis
```

这会在 `my-thesis` 目录下创建一个干净的项目：

```
my-thesis/
├── main.typ        # 论文入口：填写信息、撰写正文
├── refs.bib        # BibTeX 参考文献库
└── figures/        # 插图目录
```

模板逻辑与字体全部由 `@preview` 包提供，`main.typ` 中的 `#import` 语句会在创建时自动写入。

### 方式二：克隆 GitHub 仓库

```bash
git clone https://github.com/han0126/jsu-thesis-template.git
cd jsu-thesis-template
```

如果需要完整源代码对论文模板进行更多定制，可以选择克隆仓库。其中，控制论文格式的源代码是根目录下的 `template.typ`，随包分发的资源在 `fonts/` 和 `sources/`。

## 仓库结构

本模板参照 Typst Universe 的通行做法，将**包入口**与**用户侧入口**分离：

```
jsu-thesis-template/
├── typst.toml          # 包清单
├── template.typ        # 包入口（模板核心逻辑，用户通过 @preview 导入）
├── thumbnail.png       # Typst Universe 缩略图
├── fonts/              # 随包分发的中英文字体
│   ├── Sim/
│   │   ├── SimSun.ttf      # 宋体
│   │   ├── SimHei.ttf      # 黑体
│   │   └── SimKai.ttf      # 楷体
│   └── TimesNewRoman/      # Times New Roman（常规 / 粗体 / 斜体 / 粗斜体）
├── sources/            # 封面图片（校徽、校名标）
│   ├── logo.png
│   └── jsu.png
└── template/           # 用户侧入口目录（init 时复制给用户）
    ├── main.typ        # 用户项目入口
    ├── refs.bib        # 参考文献库
    └── figures/        # 插图目录
```

对应 `typst.toml` 的声明：

```toml
[package]
entrypoint = "template.typ"    # 包入口：用户 #import 时加载的文件

[template]
path = "template"              # 该目录内文件会被复制到用户的新项目
entrypoint = "main.typ"        # 用户项目的编译入口
thumbnail = "thumbnail.png"
```

> 这种分离带来的好处：包逻辑与资源随 `@preview` 分发，用户项目保持干净；`typst init` 只复制 `template/` 这一个目录。

## 配置说明

在 `main.typ` 中通过 `jsu-thesis` 函数配置论文信息，各参数以命名参数传入：

```typst
#import "@preview/jsu-thesis-template:0.1.0": *
#import "@preview/jsu-thesis-template:0.1.0": template as jsu-thesis

#show: jsu-thesis.with(
  zh_title: "中文论文题目",
  zh_keywords: ("关键词1", "关键词2", "关键词3"),
  zh_abstract: [摘要内容……],

  en_title: "English Title",
  en_keywords: ("Keyword 1", "Keyword 2", "Keyword 3"),
  en_abstract: [English abstract……],

  college: [XX学院],
  class: [XX班],
  author: [XX],
  number: [XXXX],
  instructor: [XX],
  post: [XX],
  year: [20XX],
  month: [X],
)

= 绪论
```

| 参数 | 类型 | 说明 | 默认值 |
| --- | --- | --- | --- |
| `zh_abstract` | content | 中文摘要正文 | `[中文摘要]` |
| `zh_title` | str | 中文论文题目 | `"中文论文题目"` |
| `zh_keywords` | array | 中文关键词（3–5 个） | `([key1], [key2], [key3])` |
| `en_abstract` | content | 英文摘要正文 | `[English abstract]` |
| `en_title` | str | 英文论文题目 | `"English title"` |
| `en_keywords` | array | 英文关键词 | `([key1], [key2], [key3])` |
| `college` | content | 学院名称 | `[学院]` |
| `class` | content | 专业班级 | `[班级]` |
| `author` | content | 学生姓名 | `[姓名]` |
| `number` | content | 学号 | `[学号]` |
| `instructor` | content | 指导教师姓名 | `[指导教师姓名]` |
| `post` | content | 指导教师职称 | `[职称]` |
| `year` | content | 年份 | `[2026]` |
| `month` | content | 月份 | `[10]` |

### 添加章节

直接使用 Typst 标准标题语法，一级标题会自动分页并居中排版：

```typst
= 绪论

正文内容……

== 研究背景

=== 国内现状
```

### 插入图片

模板提供 `img` 函数，自动处理编号与图名：

```typst
#img(
  image("figures/your-image.png", width: 60%),
  caption: [图片说明],
)
```

### 插入表格

```typst
#tbl(
  table(
    columns: (1fr, 1fr),
    align: center + horizon,
    stroke: none,
    table.hline(stroke: 1.5pt),
    table.header()[*表头1*][*表头2*],
    table.hline(stroke: 0.8pt),
    [内容1], [内容2],
    table.hline(stroke: 1.5pt),
  ),
  caption: [三线表样例],
)
```

### 公式

```typst
#equation(
  $
    max {F({t_1},{t_2})} = sum^3_(i=1) sum^5_(j=1) T(i,j) dot x_(i j)
  $
)
```

### 参考文献

编辑 `refs.bib` 后，在正文中引用：

```typst
据研究显示#cite(<key>)……
```

文末的参考文献列表已配置 GB/T 7714-2015 numeric 样式：

```typst
#heading(numbering: none)[参考文献]
#bibliography("refs.bib", style: "gb-7714-2015-numeric", title: none)
```

## 字体配置

本模板随包分发了完整的中英文字体，族名如下：

| 用途 | 字体族名 | 文件 |
| --- | --- | --- |
| 宋体 | `SimSun` | `fonts/Sim/SimSun.ttf` |
| 黑体 | `SimHei` | `fonts/Sim/SimHei.ttf` |
| 楷体 | `KaiTi` | `fonts/Sim/SimKai.ttf` |
| 英文 / 数字 | `Times New Roman` | `fonts/TimesNewRoman/*.ttf` |

**字体由包提供，从 `@preview` 创建的项目无需手动指定 `--font-path`。** 通过 `@preview` 导入时，Typst 会从包内解析字体资源。

> 若克隆仓库后在本地直接编译 `template/main.typ`，则需要额外指定字体路径（见下一节）。

### 本地开发时的字体路径

从克隆的仓库直接编译时，需显式指定字体目录：

```bash
typst compile template/main.typ --font-path fonts
```

或使用环境变量：

```bash
# Windows PowerShell
$env:TYPST_FONT_PATHS = "fonts"

# macOS / Linux
export TYPST_FONT_PATHS=fonts
```

### VS Code (Tinymist) 配置

在 VS Code 的 `settings.json` 中添加：

```json
{
  "tinymist.fontPaths": ["${workspaceFolder}/fonts"]
}
```

否则编辑器内的预览会使用回退字体，与实际编译结果不一致。

## 编译文档

### 从 Universe 创建的项目

```bash
# 生成 PDF
typst compile main.typ

# 监听文件变化并自动重新编译
typst watch main.typ

# 指定输出文件名
typst compile main.typ thesis.pdf

# 导出为图片
typst compile main.typ "page-{p}.png"
```

### 从克隆的仓库

```bash
typst compile template/main.typ --font-path fonts
```

### 在 Typst Web App 中使用

点击模板页面上的 **Create project in app** 按钮，即可在网页端创建项目。字体随包加载，网页端与本地排版一致。

## 本地验证（发布前）

仓库提供了 `verify.ps1`，可在**不上传**的前提下模拟完整的引用环境：

```powershell
powershell -ExecutionPolicy Bypass -File verify.ps1
```

脚本会依次完成：

1. 检查 `typst` 可执行文件（默认路径见脚本 `param` 块，可用 `-TypstExe` 指定）
2. 按「Universe 会收到的内容」构造模拟包（读取 `typst.toml` 的 `[package].exclude`，确保模拟包与真实发布包一致；并断言 `verify.ps1` 自身未被打入包内）
3. 执行 `typst init` 创建用户项目
4. **核对产物清单**（`init` 退出码为 0 不代表产物可用，必须检查 `main.typ` 是否存在）
5. 将入口的 `@preview` 改写为 `@local`（仅模拟需要，仓库源码保持 `@preview`）
6. 编译用户项目，并检查是否生成 PDF
7. 以 `--ignore-system-fonts` 做纯净环境编译，要求**零字体警告**

全部通过时脚本退出码为 `0` 并输出 `ALL PASSED`；任何一步失败会标出红色 `FAIL` 并返回非零退出码，便于接入 CI。

> 脚本刻意写成纯 ASCII，以兼容 Windows PowerShell 5.1 的默认编码（GBK）。
> 若脚本含中文，PS 5.1 会按 GBK 解析 UTF-8 文件而导致语法错误。

验证产物位于 `.sim/`，清理：

```powershell
Remove-Item -Recurse -Force .sim
```

### 关于 `package not found (searched for @preview/jsu-thesis-template:0.1.0)`

在模板**发布前**，于本仓库内直接编译 `template/main.typ` 会看到此报错 —— 这是**预期行为**，不是配置错误。

`@preview` 是 Typst Universe 的官方发布命名空间，模板尚未提交 PR，registry 中自然不存在该包。请勿为了本地能编译而把入口改成 `@local`，那会导致发布后用户拿到无法使用的项目。

正确的自检方式是使用 `verify.ps1`：它只在**模拟产物**中把 `@preview` 替换为 `@local`，仓库源码始终保持 `@preview`。

## 常见问题

**Q：`typst init` 报错 `failed to create project directory (Io error)`？**

通常是因为把包目录做成了**符号链接 / junction** 指回仓库自身。`init` 会递归复制 `[template].path` 目录，符号链接会形成自引用死循环。请改用实际拷贝（`robocopy` / `cp -r`）。

**Q：`typst init` 显示成功，但生成的项目缺少 `main.typ`？**

`init` 的退出码不可信。若 `[template].path` 指向的目录里没有 `entrypoint` 声明的文件，`init` 仍会报成功，但用户拿到的是不可用的项目。请用 `verify.ps1` 的第 4 步检查产物清单。

**Q：编译时提示 `unknown font family: simsun` / `simhei` / `times new roman`？**

从克隆的仓库直接编译时会出现，因为字体路径未指定。加上 `--font-path fonts` 即可。从 `@preview` 创建的项目不会遇到此问题。

**Q：目录页、页码不对？**

页码分界点由 `template.typ` 中的 `#counter(page).update(1)` 控制（正文起始处）。如需调整前置部分与正文的分界，请修改该位置。

**Q：想修改页边距或行距？**

在 `template.typ` 中搜索 `set page(` 和 `set par(`，正文字号与行距在正文段的 `#set text(...)` / `#set par(leading: ...)` 处。

**Q：`refs.bib` 是空的，参考文献怎么办？**

从文献管理工具（Zotero、JabRef 等）导出 BibTeX 格式内容粘贴进去即可，或使用 Zotero 的 Better BibTeX 插件自动同步。

**Q：想自定义章节结构？**

用户项目的 `main.typ` 是自包含的，直接增删 `= 一级标题` 即可，无需依赖其他文件。若需要更细的拆分，可自行 `#include` 其他 `.typ`。

## 致谢

感谢 Typst 社区在中文排版方面的工作。本模板的页面设置、字号系统与标题样式参考了中文排版惯例与相关开源项目。

## 许可证（License）

本项目中的 Typst 模板源代码依据 MIT 许可证进行授权。

本模板内置的字体文件（`fonts/` 目录下的 `SimSun.ttf`、`SimHei.ttf`、`SimKai.ttf`、`TimesNewRoman*.ttf`）版权归各自权利人所有，**不在 MIT 许可证授权范围内**。这些字体文件随模板一同分发仅用于学位论文排版的学术、非商业用途。使用者需自行确认其对字体的使用符合相关许可条款及适用法律法规。

校徽（`sources/logo.png`）与校名标（`sources/jsu.png`）为江苏大学标识资源，其知识产权归江苏大学所有，同样不在 MIT 许可证授权范围内，仅限用于本校学位论文排版。

The Typst template source code is licensed under the MIT License.

The font files bundled in the `fonts/` directory (`SimSun.ttf`, `SimHei.ttf`, `SimKai.ttf`, `TimesNewRoman*.ttf`) are copyrighted by their respective owners and are **excluded** from the MIT license. They are bundled solely for academic, non-commercial use in thesis formatting. Users are responsible for ensuring their use complies with the relevant license terms and applicable laws.

The university emblem (`sources/logo.png`) and wordmark (`sources/jsu.png`) are identity assets of Jiangsu University, remain the property of Jiangsu University, and are likewise excluded from the MIT license. They may be used only for thesis formatting at this institution.
