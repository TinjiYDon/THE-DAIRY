# 贡献指南

感谢你对 THE-DAIRY 的关注！

## 开发流程
- 默认分支：`main`（发布）、`dev`（活跃开发）
- 功能分支命名：`feat/*`、`fix/*`、`docs/*`
- PR 目标分支：请提交到 `dev`；发布时由维护者合并到 `main`

## DCO（开发者来源证明）
本项目采用 DCO。提交需使用 `-s` 进行签名：
```bash
git commit -s -m "feat: add companion persona selector"
```
签名即同意 DCO 条款：<https://developercertificate.org/>

## 代码规范
- 使用 Flutter 稳定版，提交前运行 `dart format` 与 `dart analyze`
- 避免对公共 API 造成破坏性变更
- 文案/人设/模板需遵循仓库内许可策略（默认 CC BY-NC）

## 如何贡献人设与模板
- 在 `assets/personas` 与 `assets/templates` 中新增/修改
- 确保 `assets/i18n/zh.arb` 与 `assets/i18n/en.arb` 存在对应键
- PR 前运行本地校验脚本（后续补充）

