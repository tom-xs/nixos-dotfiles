{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
  };

  home.packages = with pkgs; [
    git
    ripgrep
    fd
    findutils
    clang
    shellcheck
  ];

  home.sessionPath = [ "$HOME/.config/emacs/bin" ];

  xdg.configFile."doom/config.el".text = ''
    ;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

    (setq user-full-name "Tomas Xavier Santos"
          user-mail-address "tom.xaviersantos@gmail.com")

    ;; Theme
    (setq doom-theme 'doom-one)

    ;; Org Mode
    (setq org-directory "~/org/")

    ;; Line Numbers
    (setq display-line-numbers-type t)
  '';

  xdg.configFile."doom/init.el".text = ''
    ;;; $DOOMDIR/init.el -*- lexical-binding: t; -*-
    (doom! :input
           :completion
           company           ; the ultimate code completion backend
           vertico           ; the search engine of the future

           :ui
           doom              ; what makes DOOM look the way it does
           doom-dashboard    ; a nifty splash screen for Emacs
           hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
           modeline          ; snazzy, Atom-inspired modeline, plus API
           ophints           ; highlight the region an operation acts on
           (popup +defaults) ; tame sudden yet inevitable temporary windows
           vc-gutter         ; vcs diff in the fringe
           vi-tilde-fringe   ; fringe tildes to mark beyond EOB
           workspaces        ; tab emulation, persistence & separate workspaces

           :editor
           (evil +everywhere); come to the dark side, we have cookies
           file-templates    ; auto-snippets for empty files
           snippets          ; my elves. They type so I don't have to
           word-wrap         ; soft wrapping with language-aware indent

           :emacs
           dired             ; making dired pretty [functional]
           undo              ; persistent, smarter undo for your inevitable mistakes
           vc                ; version-control and Emacs, sitting in a tree

           :checkers
           syntax            ; tasing you for every semicolon you forget

           :tools
           (eval +overlay)   ; run code, run (also, repls)
           lookup            ; navigate your code and its documentation
           magit             ; a git porcelain for Emacs
           
           :lang
           emacs-lisp        ; drown in parentheses
           markdown          ; let there be form
           nix               ; I know you like Nix
           sh                ; she sells {ba,z,fi}sh shells on the C xor

           :config
           (default +bindings +smartparens))
  '';

  xdg.configFile."doom/packages.el".text = ''
    ;;; $DOOMDIR/packages.el -*- lexical-binding: t; -*-
    ;; (package! some-package)
  '';
}
