# vim-quick-cocos2d-x (Cocos2d-Lua)

This is a vim plugin for game developer which using quick-cocos2d-x ([Cocos2d-Lua](http://www.cocos.com/download/cocos2d-lua/)).

Support Cocos2d-Lua v3.3

## Feature

* Code autocomplete, shortcut key `<C-x><C-o>` or `<Tab>`.
* Run Quick Player for the project of current buffer, shortcut key `<F5>`.

Enjoy it!

## Installation

If you use [Pathogen](https://github.com/tpope/vim-pathogen), do this:

```sh
cd ~/.vim/bundle
git clone https://github.com/u0u0/vim-quick-community.git
```

> Note: plugin require Vim build with python support.
> For Windows user, need Python & Vim both are 32bit or 64bit version.

## Settings

Add this to your vimrc:

```
let g:cocos2dx_diction_location = '~/.vim/bundle/vim-quick-community/key-dict'
```