;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                           ;;
;;    EMACS configuration file by Rigidus    ;;
;;                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(add-to-list 'load-path "~/.emacs.d/")

(require 'cl)

;; pg.el (byte-compiled) v.0.12
;; http://www.online-marketwatch.com/pgel/pg.el
;; pg_hba: hostnossl all all 127.0.0.1/32 md5
(require 'pg)


(unless (require 'el-get nil t)
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))


(defun jc/mc-search (search-command)
  ;; Read new search term when not repeated command or applying to fake cursors
  (when (and (not mc--executing-command-for-fake-cursor)
             (not (eq last-command 'jc/mc-search-forward))
             (not (eq last-command 'jc/mc-search-backward)))
    (setq jc/mc-search--last-term (read-from-minibuffer "Search: ")))
  (funcall search-command jc/mc-search--last-term))

(defun jc/mc-search-forward ()
  "Simplified version of forward search that supports multiple cursors"
  (interactive)
  (jc/mc-search 'search-forward))

(defun jc/mc-search-backward ()
  "Simplified version of backward search that supports multiple cursors"
  (interactive)
  (jc/mc-search 'search-backward))

;; C-x C-e eval-and-replace

;; Evaluate the last sexp and replace it with the result. Get it here.
;; M-x kmacro-name-last-macro

;; Assign a name to the last keyboard macro defined.
;; M-x insert-kbd-macro

;; Insert in buffer the definition of kbd macro NAME, as Lisp code.


;; SBCL
(setq slime-lisp-implementations '((sbcl ("sbcl"))))
(setq slime-startup-animation nil)
;; Путь к локльной копии Common Lisp Hyper Specifications.
;; Если его не задавать - справка по функциям будет загружать страницы из интернета
;; (setq common-lisp-hyperspec-root "file:///Users/lisp/HyperSpec")

;; SLIME
;; (add-to-list 'load-path "~/.emacs.d/slime-20110829-cvs") ;; Путь к slime
(add-to-list 'load-path "/usr/share/emacs/site-lisp/slime") ;; Путь к slime
(require 'slime)
(setq slime-net-coding-system 'utf-8-unix)
(slime-setup '(slime-fancy))
(setq slime-enable-evaluate-in-emacs t)
;; swank:invoke-slime-debugger
;; (let ((*emacs-connection* ...)) (eval-in-emacs '(+ 1 2)))

;; Установка режима CUA поддержка Ctr-c,v,x,d как в windows
;; CUA mode: C-x, C-c, C-v for copying, pasting, C-z for undo
;; (cua-mode t)
;; (setq cua-keep-region-after-copy t) ;; Standard Windows behaviour
;; Настройка поведения редактора "как в Windows":
;; Delete (and its variants) delete forward instead of backward.
;; C-Backspace kills backward a word (as C-Delete normally would).
;; M-Backspace does undo.
;; Home and End move to beginning and end of line
;; C-Home and C-End move to beginning and end of buffer.
;; C-Escape does list-buffers."
;; (pc-bindings-mode)
;; (pc-selection-mode)      ;; Настройка выделения "как в Windows"
(delete-selection-mode 1)   ;; <del> и BackSpace удаляют выделенный текст
(transient-mark-mode 1)     ;; Показывать выделенный текст


;; Makes clipboard work
(setq x-select-enable-clipboard t)
;; (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; для корректного выведения escape-последовательностей shell`a
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Установки автоопределения кодировок. Первой будет определяться utf-8-unix
(prefer-coding-system 'cp866)
(prefer-coding-system 'koi8-r-unix)
(prefer-coding-system 'windows-1251-dos)
(prefer-coding-system 'utf-8-unix)

;; Удаляем оконечные пробелы перед сохранением файлов
(add-hook 'before-save-hook '(lambda ()
(delete-trailing-whitespace)))

;; Режим по умолчанию c переносом строк по ширине 130
(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq auto-fill-mode t)
(setq fill-column 130)

;; Создание резервных копий редактируемых файлов (Backup)
;; (info "(emacs)Auto Save")
(setq auto-save-interval 512)                ;; Количество нажатий до автосохранения
(setq auto-save-timeout 20)                  ;; Автосохранение в перерыве между нажатиями (в секундах)
(setq backup-directory-alist                 ;; Все временные копии в один каталог.
      '((".*" . "~/.emacs.d/backups")))      ;; Каталог создаётся автоматически.
(setq backup-by-copying t)                   ;; Режим сохранения копий
(setq version-control t)                     ;; Создавать копии с номерами версий
(setq delete-old-versions t)                 ;; Удалять старые версии без подтверждения
(setq kept-new-versions 6)                   ;; нумерованный бэкап - 2 первых и 2 последних
(setq kept-old-versions 2)


;; Оптимизация работы редактора
;; limit on number of Lisp variable bindings & unwind-protects
(setq max-specpdl-size (* 10 max-specpdl-size)) ; 10 * 1 M (default)
;; limit serving to catch infinite recursions for you before they
;; cause actual stack overflow in C, which would be fatal for Emacs
(setq max-lisp-eval-depth (* 10 max-lisp-eval-depth)) ; 10 * 400 (default)
;; speed up things by preventing garbage collections
(setq gc-cons-threshold (* 10 gc-cons-threshold)) ; 10 * 400 KB (default)

;; Интерфейс

;; Делаем емакс аскетичным
(menu-bar-mode nil)
;; (tool-bar-mode nil)
;; (scroll-bar-mode nil)
(setq column-number-mode t)                  ;; Показывать номер текущей колонки
(setq line-number-mode t)                    ;; Показывать номер текущей строки
;; (set-scroll-bar-mode 'right)                 ;; Полоса прокрутки справа
(setq inhibit-startup-message t)             ;; Не показываем сообщение при старте
(fset 'yes-or-no-p 'y-or-n-p)		         ;; не заставляйте меня печать "yes" целиком
(setq echo-keystrokes 0.001)                 ;; Мгновенное отображение набранных сочетаний клавиш
(setq use-dialog-boxes nil)                  ;; Не использовать диалоговые окна
(setq cursor-in-non-selected-windows nil)    ;; Не показывать курсоры в неактивных окнах
(setq default-tab-width 4)                   ;; размер табуляции
(setq c-basic-offset 4)                      ;; табуляция для режимов, основанных на c-mode
(setq tab-width 4)
(setq cperl-indent-level 4)
(setq sgml-basic-offset 4)                   ;; для HTML и XML
(setq-default indent-tabs-mode nil)          ;; отступ только пробелами
(setq initial-scratch-message nil)           ;; Scratch buffer settings. Очищаем его.
(setq case-fold-search t)                    ;; Поиск без учёта регистра
(global-font-lock-mode t)                    ;; Поддержка различных начертаний шрифтов в буфере
(setq font-lock-maximum-decoration t)        ;; Максимальное использование различных начертаний шрифтов
(if window-system (setq scalable-fonts-allowed t)) ;; Масштабируемые шрифты в графическом интерфейсе
(setq read-file-name-completion-ignore-case t) ;; Дополнение имён файлов без учёта регистра
(file-name-shadow-mode t)                    ;; Затенять игнорируемую часть имени файла
(setq resize-mini-windows t)                 ;; Изменять при необходимости размер минибуфера по вертикали
(auto-image-file-mode t)                     ;; Показывать картинки
(setq read-quoted-char-radix 10)             ;; Ввод символов по коду в десятичном счислении `C-q'
(put 'narrow-to-region 'disabled nil)        ;; Разрешить ограничение редактирования только в выделенном участке
(put 'narrow-to-page 'disabled nil)          ;; Разрешить ограничение редактирования только на текущей странице
(setq scroll-step 1)                         ;; Перематывать по одной строке
(setq temp-buffer-max-height                 ;; Максимальная высота временного буфера
      (lambda (buffer)
        (/ (- (frame-height) 2) 3)))
(temp-buffer-resize-mode t) ;; Высота временного буфера зависит от его содержимого
(setq frame-title-format '("" "%b @ Emacs " emacs-version)) ;; Заголовок окна


(setq scroll-conservatively 50)              ;; гладкий скроллинг с полями
(setq scroll-preserve-screen-position 't)
(setq scroll-margin 10)

(setq my-author-name (getenv "USER"))
(setq user-full-name (getenv "USER"))
(setq require-final-newline t)			     ;; always end a file with a newline

;; Красный не мигающий (!) курсор
(set-cursor-color "red")
(blink-cursor-mode nil)
;; мышка...
(global-set-key [vertical-scroll-bar down-mouse-1] 'scroll-bar-drag) ;; Scroll Bar gets dragged by mouse butn 1
(setq mouse-yank-at-point 't) 		    ;; Paste at point NOT at cursor


(show-paren-mode 1)                     ;; выделение парных скобок
;(setq show-paren-style 'expression)    ;; выделять все выражение в скобках
										;; отступ при переводе строки в lisp-mode
(add-hook 'lisp-mode-hook
		  '(lambda ()
			(local-set-key (kbd "RET") 'newline-and-indent)))




;; http://kulchitsky.org/rus/linux/dotemacs.html
;; Установка раскладки как в виндовс при переключении по С-\

(global-set-key (kbd "\C-\\") 'user-toggle-input-method)
(global-set-key (kbd "\e(") 'user-to-cyr) ; Alt+Shift+9
(global-set-key (kbd "\e)") 'user-to-nil) ; Alt+Shift+0


;;(set-input-method "russian-computer")

(defun user-cyrillic-redefinitions ()
  "Set of global keys binding for cyrillic.
   This function is to be called from user-toggle-input-method"
  (global-set-key (kbd "?") (lambda()(interactive)(insert ",")))
  (global-set-key (kbd "/") (lambda()(interactive)(insert ".")))
  (global-set-key (kbd ",") (lambda()(interactive)(insert ":")))
  (global-set-key (kbd ":") (lambda()(interactive)(insert "%")))
  (global-set-key (kbd "*") (lambda()(interactive)(insert ";")))
  (global-set-key (kbd ";") (lambda()(interactive)(insert "*")))
  (global-set-key (kbd ".") (lambda()(interactive)(insert "?"))))

(defun user-nil-redefinitions ()
 "Restoring global keys binding after user-cyrillic-redefinitions.
  This function is to be called from user-toggle-input-method"
  (global-set-key (kbd "?") (lambda()(interactive)(self-insert-command 1)))
  (global-set-key (kbd "/") (lambda()(interactive)(self-insert-command 1)))
  (global-set-key (kbd "$") (lambda()(interactive)(self-insert-command 1)))
  (global-set-key (kbd ",") (lambda()(interactive)(self-insert-command 1)))
  (global-set-key (kbd ":") (lambda()(interactive)(self-insert-command 1)))
  (global-set-key (kbd "*") (lambda()(interactive)(self-insert-command 1)))
  (global-set-key (kbd ";") (lambda()(interactive)(self-insert-command 1)))
  (global-set-key (kbd ".") (lambda()(interactive)(self-insert-command 1))))

(defun user-toggle-input-method ()
  "Change the stadart function tuggle-input-method
   to redefine keys for cyrillic input from UNIX type to win type"
  (interactive)
  (toggle-input-method)
  (if (string= current-input-method "cyrillic-jcuken")
      (user-cyrillic-redefinitions)
    (user-nil-redefinitions))
  (message "keybord changed to %s" current-input-method))

(defun user-to-cyr ()
  "Change input method to Cyrillic,
   I bound this function with Alt-Shift-9, that is M-("
  (interactive)
  (when (string= current-input-method nil)
      (user-toggle-input-method)))

(defun user-to-nil ()
  "Change input method to nil (generally to English),
   I bound this function with Alt-Sfift-0 that is M-)"
  (interactive)
  (when (string= current-input-method "cyrillic-jcuken")
      (user-toggle-input-method)))


;;(user-toggle-input-method)

;; Итак, я предлагаю команду 'Meta-Meta-Shift-/' для того, чтобы запомнить текущую позицию
;; и команду 'Meta-Meta-/' для того, чтобы перейти на запомненную позицию, прежде запомнив текущую.
;;Toggle between saved positions as in MIM editor
(defun save-point-and-switch ()
  "Save current point to register 0 and go
to the previously saved position"
 (interactive)
 (let (temp)
   (setq temp (point-marker))
   (when (not (equal (get-register 0) nil))
     (jump-to-register 0))
   (set-register 0 temp)))

;;Save current position to register 0
(defun save-point-only ()
 "Save current point to register 0"
 (interactive)
 (set-register 0 (point-marker)))

(global-set-key (kbd "\e\e/") 'save-point-and-switch)
(global-set-key (kbd "\e\e?") 'save-point-only)


;; Comment function
(defun comment-or-uncomment-this (&optional lines)
  (interactive "P")
  (if mark-active
      (if (< (mark) (point))
          (comment-or-uncomment-region (mark) (point))
          (comment-or-uncomment-region (point) (mark)))
      (comment-or-uncomment-region
       (line-beginning-position)
       (line-end-position lines))))
;; (global-set-key (kbd "C-;") ;; не работает в консольном режиме
;; 				'comment-or-uncomment-this)
(global-set-key (kbd "C-x /")
				'comment-or-uncomment-this)


;; Автоматическое выравнивание вставляемого из буфера обмена кода
(defadvice yank (after indent-region activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode c-mode c++-mode
                                objc-mode latex-mode plain-tex-mode python-mode))
      (indent-region (region-beginning) (region-end) nil)))
(defadvice yank-pop (after indent-region activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode c-mode c++-mode
                                objc-mode latex-mode plain-tex-mode python-mode))
      (indent-region (region-beginning) (region-end) nil)))


;; Поиск от kostafey C-f|C-r C-v
(global-unset-key "\C-f")
(global-set-key "\C-f" 'isearch-forward)
(global-set-key "\C-r" 'isearch-backward)
(add-hook 'isearch-mode-hook
		  '(lambda ()
			 (define-key isearch-mode-map "\C-f"
			   'isearch-repeat-forward)
			 (define-key isearch-mode-map "\C-r"
			   'isearch-repeat-backward)
			 (define-key isearch-mode-map "\C-v"
			   'isearch-yank-kill)))


;; ;; conkeror-browser
;; (eval-after-load "browse-url"
;;   '(defun browse-url-conkeror (url &optional new-window)
;;      "Ask the Conkeror WWW browser to load URL."
;;      (interactive (browse-url-interactive-arg "URL: "))
;;      ;; URL encode any `confusing' characters in the URL. This needs to
;;      ;; include at least commas; presumably also close parens and dollars.
;;      (while (string-match "[,)$]" url)
;;        (setq url (replace-match
;; 				  (format "%%%x" (string-to-char (match-string 0 url)))
;; 				  t t url)))
;;      (let* ((process-environment (browse-url-process-environment))
;; 			(process
;; 			 (apply 'start-process
;; 					(concat "conkeror " url)
;; 					nil "conkeror"
;; 					(list url)))))))
;; ;; set conkeror-browser
;; (setq browse-url-browser-function 'browse-url-conkeror)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; EXTENSIONS ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; UNIQUIFY
;; http://emacswiki.org/emacs/uniquify
(require 'uniquify)
;; (setq uniquify-buffer-name-style t)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")
(setq post-forward-angle-brackets 'post-forward-angle-brackets)


;; IBUFFER - Более удобный переключатель буферов
(require 'ibuffer)
(global-set-key [?\C-x ?\C-b] 'ibuffer)
;; Пропускать буферы с именем, удовлетворяющим регулярному выражению
(setq ibuffer-never-show-predicates
      (list "^\\*Complet" "^\\*Compile-Log" "^\\*Quail" "^\\*fsm-debug"))
;; Сортировать буферы по теме
(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("C/CPP"     (or
                              (mode . c-mode)
                              (mode . c++-mode)))
               ("ERLANG"    (or
                              (mode . erlang-mode)))
               ("JS"        (or
                              (mode . espresso-mode)))
               ("CSS"       (or
                              (mode . css-mode)))
               ("HTML"      (or
                              (mode . html-mode)
                              (mode . closure-template-html-mode)))
               ("CHAT"      (or
                              (name . "^\\*---.*")))
               ("CONF"      (or
                              (name . "^\\*===.*")))
               ("JABBER"    (or
                              (name . "^\\*-jabber-roster.*")))
               ("SYS"       (or
                              (mode . dired-mode)
                              (name . "^\\*scratch\\*$")
                              (name . "^\\*Messages\\*$")))
               ("SHELL"     (or
                              (name . "^\\*Shell\\*$")
                              (name . "^\\*grep\\*$")))
               ("REPL"      (or
                              (name . "^\\*inferior-lisp.*")
                              (name . "^\\*slime-events.*")
                              (name . "^\\*slime-repl.*")
                              (name . "^\\*Python.*")
                              (name . "*\\*sldb.*")))
               ("ORG"       (or
                              (mode . org-mode)))
               ("LISP"      (or
                              (mode . lisp-mode)))
               ("ELISP"     (or
                              (mode . elisp-mode)
                              (mode . emacs-lisp-mode)))))))
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups
             "default")))
(setq ibuffer-formats
      (quote ((mark modified read-only " "
                    (name 32 32 :left :elide) " "
                    (size 9 -1 :right) " "
                    (mode 16 16 :left :elide) " " filename-and-process)
              (mark " " (name 16 -1) " " filename))))


;; ;; IDO-MODE
;; ;; C-s/C-r перебирают варианты
;; ;; M-p/M-n проходят по истории историю.
;; (require 'ido)
;; (ido-mode t)
;; (setq ido-enable-flex-matching t)

;; ISWITCHB http://www.emacswiki.org/emacs/IswitchBuffers
(require 'iswitchb)
(defun iswitchb-local-keys ()
  (mapc (lambda (K)
	      (let* ((key (car K)) (fun (cdr K)))
            (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
	    '(("<right>" . iswitchb-next-match)
	      ("<left>"  . iswitchb-prev-match)
	      ("<up>"    . ignore             )
	      ("<down>"  . ignore             ))))
(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)
;; http://www.emacswiki.org/emacs/IswitchBuffers
(defadvice iswitchb-kill-buffer (after rescan-after-kill activate)
  "*Regenerate the list of matching buffer names after a kill.
    Necessary if using `uniquify' with `uniquify-after-kill-buffer-p'
    set to non-nil."
  (setq iswitchb-buflist iswitchb-matches)
  (iswitchb-rescan))
;; http://www.emacswiki.org/emacs/IswitchBuffers
(defun iswitchb-rescan ()
  "*Regenerate the list of matching buffer names."
  (interactive)
  (iswitchb-make-buflist iswitchb-default)
  (setq iswitchb-rescan t))

;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/") 		; указываем где будут лежать файлы расширений
;;;;;;;;;;;;;;;;;;;;;;;;;;


;; HTMLIZE
(require 'htmlize)

;; DIRED-SINGLE
(require 'dired-single)

(defun my-dired-init ()
  "Bunch of stuff to run for dired, either immediately or when it's
        loaded."
  ;; <add other stuff here>
  (define-key dired-mode-map [return] 'joc-dired-single-buffer)
  (define-key dired-mode-map [mouse-1] 'joc-dired-single-buffer-mouse)
  (define-key dired-mode-map "^"
    (function
     (lambda nil (interactive) (joc-dired-single-buffer "..")))))

;; if dired's already loaded, then the keymap will be bound
(if (boundp 'dired-mode-map)
    ;; we're good to go; just add our bindings
    (my-dired-init)
  ;; it's not loaded yet, so add our bindings to the load-hook
  (add-hook 'dired-load-hook 'my-dired-init))

(global-set-key [(f5)] 'joc-dired-magic-buffer)
(global-set-key [(control f5)] (function (lambda nil (interactive) (joc-dired-magic-buffer default-directory))))
(global-set-key [(shift f5)] (function (lambda nil (interactive) (message "Current directory is: %s" default-directory))))
(global-set-key [(meta f5)] 'joc-dired-toggle-buffer-name)

;; http://www.emacswiki.org/emacs/DiredReuseDirectoryBuffer
(put 'dired-find-alternate-file 'disabled nil)


;; FULLSCREEN
(require 'fullscreen)
(global-set-key (kbd "C-c f") 'fullscreen-toggle)


;; COLOR-THEME
;; http://habrahabr.ru/blogs/emacs/25854/
;; http://download.gna.org/color-theme/
(require 'color-theme) 				; подгружаем "модуль раскраски"
;; выбрать конкретную схему
;; ;; universal
;; (color-theme-tty-dark)
;; (color-theme-ld-dark)
;; ;; night
;; (color-theme-charcoal-black)
;; (color-theme-gray30)
;; ;; evil night
;; (color-theme-arjen)
;; (color-theme-billw)
;; (color-theme-clarity)
;; (color-theme-dark-green)
;; (color-theme-dark-info)
;; (color-theme-clarity)
;; (color-theme-dark-laptop)
;; ;; sleep night (low contrast)
;; (color-theme-calm-forest)
;; (color-theme-euphoria)
;; (color-theme-fischmeister)
;; (color-theme-goldenrod)
;; (color-theme-lawrence) ;; real matrix in gui
;; ;; only gui
;; (color-theme-shaman)


;; HL-P
;; http://nschum.de/src/emacs/highlight-parentheses/highlight-parentheses.el
(require 'highlight-parentheses)
;; (add-hook 'lisp-mode-hook (highlight-parentheses-mode))
(define-globalized-minor-mode global-highlight-parentheses-mode
	highlight-parentheses-mode highlight-parentheses-mode)
(setq hl-paren-colors
'("#FF0000" "#FFBF00" "#1FFF00" "#009EFF" "#2100FF" "gray10" "gray70" "gray90"))
(global-highlight-parentheses-mode)


;; LJ-UPDATE
(add-to-list 'load-path "~/.emacs.d/ljupdate")
(require 'ljupdate)

;; CLOSURE-TEMPLATE-HTML-MODE
;; http://github.com/archimag/cl-closure-template/raw/master/closure-template-html-mode.el
(require 'closure-template-html-mode)

;; PHP - HTML - JAVASCRIPT
;; http://php-mode.svn.sourceforge.net/svnroot/php-mode/tags/php-mode-1.5.0/php-mode.el
(add-to-list 'load-path "~/.emacs.d/php-mode")
(require 'php-mode) 						; подгружаем php режим
;; http://www.stcamp.net/share/php-electric.el
(require 'php-electric)						; режим autocompletion конструкций языка
;; http://download-mirror.savannah.gnu.org/releases/espresso/espresso.el
(autoload #'espresso-mode "espresso" "Start espresso-mode" t)
(add-to-list 'auto-mode-alist '("\\.js$" . espresso-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . espresso-mode))
(add-hook 'espresso-mode-hook 'moz-minor-mode)
(add-hook 'espresso-mode-hook 'esk-paredit-nonlisp)
(add-hook 'espresso-mode-hook 'run-coding-hook)
(setq espresso-indent-level 2)
;; If you prefer js2-mode, use this instead:
;; (add-to-list 'auto-mode-alist '("\\.js$" . espresso-mode))
(eval-after-load 'espresso
  '(progn ;; fixes problem with pretty function font-lock
          (define-key espresso-mode-map (kbd ",") 'self-insert-command)
          (font-lock-add-keywords
           'espresso-mode `(("\\(function *\\)("
                             (0 (progn (compose-region (match-beginning 1)
                                                       (match-end 1) "ƒ")
                                       nil)))))))


;; SGML-MODE

(load "sgml-mode")
(add-to-list 'auto-mode-alist '("\\.html$" . sgml-mode))
(add-to-list 'auto-mode-alist '("\\.phtml$" . sgml-mode))
(add-to-list 'auto-mode-alist '("\\.xml$" . sgml-mode))
;;sgml vars
(setq sgml-balanced-tag-edit t)
(setq sgml-auto-insert-required-elements t)
(setq sgml-insert-defaulted-attributes t)
(setq sgml-tag-region-if-active t)
(setq sgml-insert-element t)
(setq sgml-set-face t)
(setq sgml-live-element-indicator t)

(setq case-fold-search t)
(setq read-file-name-completion-ignore-case t)
(show-paren-mode t)
(put 'upcase-region 'disabled nil)



;; Далее, мой любимый «режим сокращений». Возможно не поддерживается автором?
;; С его помощью можно уменьшить количество ударов по кнопкам клавиатуры.
;; http://www.bloomington.in.us/~brutt/msf-abbrev.html
(require 'msf-abbrev) 						; подгружаем "режим сокращений"
(setq-default abbrev-mode t) 				; ставим его по дефолту
(setq save-abbrevs nil) 					; не надо записывать в дефолтный каталог наши сокращения
(setq msf-abbrev-root "~/.emacs.d/abb") 	; надо записывать их сюда
(global-set-key 							; (Ctrl-c a) для создания нового сокращения
	(kbd "C-c a")
	'msf-abbrev-define-new-abbrev-this-mode)
(msf-abbrev-load) 							; пусть этот режим будет всегда :)



;; YASNIPPET
(add-to-list 'load-path "~/.emacs.d/yasnippet-0.6.1c")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet-0.6.1c/snippets")


;; IRC

(require 'erc)
(setq erc-modules '(autojoin button completion irccontrols match menu
                             netsplit noncommands readonly ring services
                             stamp spelling track fill))
(require 'erc-services)
(erc-services-mode 1)
(erc-fill-mode t)
(erc-log-mode 1)
(erc-autojoin-mode t)

;; Если я правильно помню, тут соответствие имени сервера, имени сети и адреса сервера
(setq erc-server-alist '(("freenode.org" irc.freenode.net "irc.freenode.net" 6667)))

;; Настройки Nickserv для разных irc-сетей, что-то из swamp тут
;; лишнее, не помню, какой именно
(setq erc-prompt-for-nickserv-password nil)
(setq erc-nickserv-passwords
      '((irc.freenode.ru (("rigidus" . "*****")))
        ;; (swamp (("rigidus" . "******")))
        ;; ("irc.swamp.ru" (("rigidus" .  "******")))
        ))

(setq erc-encoding-coding-alist '(("#programmers" . cp1251)))
(setq erc-interpret-controls-p 'remove)
(setq erc-nick "rigidus")
(setq erc-nicklist-use-icons nil)
(setq erc-notice-highlight-type 'all)
(setq erc-paranoid t)
(setq erc-join-buffer 'bury)
(setq erc-pcomplete-nick-postfix "")
(setq erc-server "irc.ircnet.su")
(setq erc-port 6669)
(setq erc-server-coding-system '(utf-8 . undecided))
(setq erc-user-full-name "yoda")
(setq erc-prompt "$")
(setq erc-insert-timestamp-function 'erc-insert-timestamp-left)
(setq erc-track-exclude-types '("JOIN" "KICK" "NICK" "PART" "QUIT" "MODE"))
(setq erc-log-channels-directory "~/.history/emacs-irc/")
(setq erc-save-buffer-on-part t)
(setq erc-max-buffer-size 10000)
(setq erc-autojoin-channels-alist '(("irc.ircnet.su" "#programmers")
                                    ("irc.nov.ru" "#programmers")
                                    ("irc.swamp.ru" "#quake")))

(defun string-list-match (lst s)
  (if lst
      (if (string-match (car lst) s)
          t
        (string-list-match (cdr lst) s))
    nil))

;; Для дёргания nickserv'а после соединения
(add-hook 'erc-after-connect
          (lambda (server nick)
            (cond
             ((string-list-match '("irc\\.nov\\.ru"
                                   ".*irc\\.ircnet\\.su.*")
                                 server)
                                        ;(erc-message "PRIVMSG" "NickServ identify ***")
              )
             ((string-match "irc\\.swamp\\.ru" server)
              (erc-message "PRIVMSG" "NickServ identify *****")
              (erc-send-command "oper sprinter ******")))))

;; Выставляет cp1251 для определённых irc-серверов
(defun choose-irc-coding (target)
  (let ((name (buffer-name (erc-server-buffer))))
    (cond
     ((string-list-match '(".*irc\\.nov\\.ru.*"
                           ".*irc\\.ircnet\\.su.*"
                           ".*irc\\.ptlink\\.ru.*")
                         name)
      'cp1251)
     (t 'utf-8))))
(setq erc-server-coding-system 'choose-irc-coding)

(defun erc-cmd-BAN (nick)
  (let* ((chan (erc-default-target))
         (who (erc-get-server-user nick))
         (host (erc-server-user-host who))
         (user (erc-server-user-login who)))
    (erc-send-command (format "MODE %s +b *!%s@%s" chan user host))))

(defun erc-cmd-KICKBAN (nick &rest reason)
  (let ((reason (if reason
                    (mapconcat #'identity reason " ")
                  "Kicked (kickban)")))
    (erc-cmd-BAN nick)
    (erc-send-command (format "KICK %s %s %s"
                              (erc-default-target)
                              nick
                              reason))))

;; Игнорирование определённых сообщений
(defun y-erc-ignore-hook (msg)
  (cond
   ((string-list-match
     '("blahblahblah (.....) has \\(joined\\|left\\) channel"
       "^\\* nick_of_stupid_user .*")
     msg)
    (setq erc-insert-this nil))))
(add-hook 'erc-insert-pre-hook (lambda (m) (y-erc-ignore-hook m)))



;; JABBER
(add-to-list 'load-path "~/.emacs.d/emacs-jabber")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/emacs-jabber")
(require 'jabber)
(setq jabber-auto-reconnect t)
(setq jabber-chat-buffer-format "*---%n-*")
(setq jabber-groupchat-buffer-format "*===%n-*")
(setq jabber-history-dir "~/.jabber-chatlogs")
(setq jabber-history-enabled t)
(setq jabber-history-muc-enabled t)
(setq jabber-history-size-limit 1024000000)
;; M-x jabber-edit-bookmarks - для редактирвания закладок


;; WANDERLUST
;; http://www.gohome.org/wl/doc/wl_95.html#SEC95
;; http://box.matto.nl/emacsgmail.html
;; http://www.emacswiki.org/emacs/hgw-init-wl.el

(add-to-list 'load-path "~/.emacs.d/el-get/wanderlust/site-lisp/wl")

(autoload 'wl "wl" "Wanderlust" t)
(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

(setq mime-edit-split-message nil)

(setq wl-from "rigidus <i.am.rigidus@gmail.com>")
(setq elmo-imap4-default-user "i.am.rigidus"
      elmo-imap4-default-server "imap.gmail.com"
      elmo-imap4-default-port 993
      elmo-imap4-default-authenticate-type 'clear
      elmo-imap4-default-stream-type 'ssl
      elmo-imap4-use-modified-utf7 t

      wl-message-id-domain "i.am.rigidus@gmail.com"
      wl-from "i.am.rigidus <i.am.rigidus@gmail.com>"
      wl-smtp-posting-server "smtp.gmail.com"
      wl-smtp-connection-type 'starttls
      wl-smtp-posting-port 587
      wl-smtp-authenticate-type "plain"
      wl-smtp-posting-user "i.am.rigidus"
      wl-local-domain "gmail.com"

      elmo-pop3-debug t
      ssl-certificate-verification-policy 1
      wl-default-folder "%inbox"
      wl-default-spec "%"
      wl-folder-check-async t
      wl-thread-indent-level 4
      wl-thread-have-younger-brother-str "+"
      wl-thread-youngest-child-str       "+"
      wl-thread-vertical-str             "|"
      wl-thread-horizontal-str           "-"
      wl-thread-space-str                " "
      wl-summary-width	nil
      wl-summary-line-format "%n%T%P %W %D-%M-%Y %h:%m %t%[%c %f% %] %s"
      wl-message-buffer-prefetch-folder-type-list nil
      mime-transfer-level 8
      mime-edit-split-message nil
      mime-edit-message-max-length 32768
      mime-header-accept-quoted-encoded-words t
      ;; mime-browse-url-function 'browse-url-conkeror
      pgg-passphrase-cache-expiry 300
      pgg-decrypt-automatically t
      wl-message-ignored-field-list '("^.*")
      wl-message-visible-field-list '("^From:" "^To:" "^Cc:" "^Date:" "^Subject:" "^User-Agent:" "^X-Mailer:")
      wl-message-sort-field-list    wl-message-visible-field-list
      wl-message-window-size '(1 . 3)
      wl-folder-window-width 40
      wl-draft-preview-attributes-buffer-lines 7
      wl-draft-config-alist
      '(
        ((string-match "avenger" wl-draft-parent-folder)
         (wl-message-id-domain . "avenger-f@yandex.ru")
         (wl-from . "rigidus <avenger-f@yandex.ru>")
         ("From" . "avenger-f@yandex.ru")
         ;; ("Fcc" . "%Sent:avenger-f@yandex.ru:993")
         (wl-smtp-posting-server . "smtp.yandex.ru")
         ;; (wl-smtp-connection-type . nil)
         (wl-smtp-connection-type . 'starttls)
         ;; (wl-smtp-connection-type . 'ssl)
         ;; (wl-smtp-posting-port . 25)
         ;; (wl-smtp-posting-port . 465)
         (wl-smtp-posting-port . 587)
         (wl-smtp-authenticate-type . "plain")
         (wl-smtp-posting-user . "avenger-f")
         (wl-local-domain . "yandex.ru")
         )
        ((string-match "content3208080" wl-draft-parent-folder)
         (wl-message-id-domain . "content3208080@yandex.ru")
         (wl-from . "content3208080 <content3208080@yandex.ru>")
         ("From" . "content3208080@yandex.ru")
         (wl-smtp-posting-server . "smtp.yandex.ru")
         (wl-smtp-connection-type . 'starttls)
         (wl-smtp-posting-port . 587)
         (wl-smtp-authenticate-type . "plain")
         (wl-smtp-posting-user . "content3208080")
         (wl-local-domain . "yandex.ru")
         )
        ((string-match "i.am.rigidus" wl-draft-parent-folder)
         (wl-message-id-domain . "i.am.rigidus@gmail.com")
         (wl-from . "i.am.rigidus <i.am.rigidus@gmail.com>")
         ("From" . "i.am.rigidus@gmail.com")
         (wl-smtp-posting-server . "smtp.gmail.com")
         (wl-smtp-connection-type . 'starttls)
         (wl-smtp-posting-port . 587)
         (wl-smtp-authenticate-type . "plain")
         (wl-smtp-posting-user . "i.am.rigidus")
         (wl-local-domain . "gmail.com")
         )
        ((string-match "avenger.rigidus" wl-draft-parent-folder)
         (wl-message-id-domain . "avenger.rigidus@gmail.com")
         (wl-from . "avenger.rigidus <avenger.rigidus@gmail.com>")
         ("From" . "avenger.rigidus@gmail.com")
         (wl-smtp-posting-server . "smtp.gmail.com")
         (wl-smtp-connection-type . 'starttls)
         (wl-smtp-posting-port . 587)
         (wl-smtp-authenticate-type . "plain")
         (wl-smtp-posting-user . "avenger.rigidus")
         (wl-local-domain . "gmail.com")
         )
        )
      )

(autoload 'wl-user-agent-compose "wl-draft" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'wl-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'wl-user-agent
      'wl-user-agent-compose
      'wl-draft-send
      'wl-draft-kill
      'mail-send-hook))


;; ;; Load CEDET.
;; ;; See cedet/common/cedet.info for configuration details.
;; (load-file "~/.emacs.d/cedet/common/cedet.el")
;; ;; Enable EDE (Project Management) features
;; (global-ede-mode 1)
;; ;; Enable EDE for a pre-existing C++ project
;; ;; (ede-cpp-root-project "NAME" :file "~/myproject/Makefile")
;; ;; Enabling Semantic (code-parsing, smart completion) features
;; ;; Select one of the following:
;; ;; * This enables the database and idle reparse engines
;; (semantic-load-enable-minimum-features)
;; ;; * This enables some tools useful for coding, such as summary mode
;; ;;   imenu support, and the semantic navigator
;; (semantic-load-enable-code-helpers)
;; ;; * This enables even more coding tools such as intellisense mode
;; ;;   decoration mode, and stickyfunc mode (plus regular code helpers)
;; ;; (semantic-load-enable-gaudy-code-helpers)
;; ;; * This enables the use of Exuberent ctags if you have it installed.
;; ;;   If you use C++ templates or boost, you should NOT enable it.
;; ;; (semantic-load-enable-all-exuberent-ctags-support)
;; ;;   Or, use one of these two types of support.
;; ;;   Add support for new languges only via ctags.
;; ;; (semantic-load-enable-primary-exuberent-ctags-support)
;; ;;   Add support for using ctags as a backup parser.
;; ;; (semantic-load-enable-secondary-exuberent-ctags-support)
;; ;; Enable SRecode (Template management) minor-mode.
;; ;; (global-srecode-minor-mode 1)
;; ;; from yakor_spb@emacs.conference.jabber.ru
;; (semantic-load-enable-excessive-code-helpers)
;; ;; Code Folding ; http://alexott-ru.blogspot.com/2009/01/blog-post.html
;; (defun my-semantic-hook ()
;;   (semantic-tag-folding-mode 1))
;; (add-hook 'semantic-init-hooks 'my-semantic-hook)

;; (global-set-key (kbd "C-x +") 'semantic-tag-folding-show-block)
;; (global-set-key (kbd "C-x -") 'semantic-tag-folding-fold-block)

;; Load ECB
(add-to-list 'load-path "~/.emacs.d/ecb")
(require 'ecb-autoloads)
(global-set-key (kbd "C-x p") 'ecb-activate)
(global-set-key (kbd "C-x j") 'ecb-deactivate)
(global-set-key (kbd "C-x ,") 'ecb-toggle-ecb-windows)
(define-key global-map (kbd "C-<tab>") 'workspace-controller)
(setq ecb-tip-of-the-day nil)
(setq ecb-prescan-directories-for-emptyness nil)


;; GOTOLINE
(global-set-key [?\M-g] 'goto-line)
(global-set-key (kbd "\e\eg") 'goto-line)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; UTILITES ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Заменить окончания строк в формате DOS ^M на Unix
(defun dos-to-unix ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\r" nil t)
      (replace-match ""))))

;; Удалить пробельные символы в конце строк
(defun delete-trailing-whitespaces ()
  (interactive "*")
  (delete-trailing-whitespace))

;; Поиск в Google по содержимому региона
(defun google-region (beg end)
  "Google the selected region."
  (interactive "r")
  (browse-url (concat "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
                      (buffer-substring beg end))))

;; Поиск в Yandex по содержимому региона
(defun yandex-region (beg end)
  "Google the selected region."
  (interactive "r")
  (browse-url (concat "http://yandex.ru/yandsearch?text="
                      (buffer-substring beg end))))



;; (mapc #'(lambda (file)
;;           (find-file file)
;;           (slime-compile-region 1 (length (buffer-string)))
;;           (read-char)
;;           (kill-buffer (current-buffer))
;;           )
;;       '("~/320-8080.ru/htlisp/my.lisp"
;;         "~/320-8080.ru/htlisp/option-class.lisp"
;;         "~/320-8080.ru/htlisp/optgroup-class.lisp"
;;         "~/320-8080.ru/htlisp/optlist-class.lisp"
;;         "~/320-8080.ru/htlisp/product-class.lisp"
;;         "~/320-8080.ru/htlisp/filter-class.lisp"
;;         "~/320-8080.ru/htlisp/group-class.lisp"
;;         "~/320-8080.ru/htlisp/wolfor-stuff.lisp"
;;         "~/320-8080.ru/htlisp/xls.lisp"
;;         "~/320-8080.ru/htlisp/trans.lisp"
;;         "~/320-8080.ru/htlisp/service.lisp"
;;         "~/320-8080.ru/htlisp/cart.lisp"
;;         "~/320-8080.ru/htlisp/checkout.lisp"
;;         "~/320-8080.ru/htlisp/gateway.lisp"
;;         "~/320-8080.ru/htlisp/search.lisp"
;;         "~/320-8080.ru/htlisp/html.lisp"
;;         "~/320-8080.ru/htlisp/conditions.lisp"
;;         "~/320-8080.ru/htlisp/actions.lisp"
;;         "~/320-8080.ru/htlisp/rule-class.lisp"
;;         "~/320-8080.ru/htlisp/agent-class.lisp"
;;         "~/320-8080.ru/htlisp/parser.lisp"
;;         "~/320-8080.ru/htlisp/data.lisp"
;;         "~/320-8080.ru/htlisp/update.lisp"
;;         "~/320-8080.ru/htlisp/outload.lisp"
;;         "~/320-8080.ru/htlisp/admin.lisp"
;;         ))


;; (mapc #'(lambda (file)
;;           (find-file file)
;;           (slime-compile-region 1 (length (buffer-string)))
;;           (read-char)
;;           ;; (kill-buffer (current-buffer))
;;           )
;;       '("~/cl-eshop/my.lisp"
;;         "~/cl-eshop/option-class.lisp"
;;         "~/cl-eshop/optgroup-class.lisp"
;;         "~/cl-eshop/optlist-class.lisp"
;;         "~/cl-eshop/product-class.lisp"
;;         "~/cl-eshop/filter-class.lisp"
;;         "~/cl-eshop/group-class.lisp"
;; ))

;; (mapc #'(lambda (file)
;;           (find-file file)
;;           (slime-compile-region 1 (length (buffer-string)))
;;           (read-char)
;;           ;; (kill-buffer (current-buffer))
;;           )
;;       '("~/cl-eshop/cart.lisp"
;;         "~/cl-eshop/gateway.lisp"
;;         "~/cl-eshop/search.lisp"
;;         "~/cl-eshop/wolfor-stuff.lisp"
;;         ))


;; OrgMode
(require 'org-install)
;; Включение автоматического переключения в Org Mode при открытии файла с расширением .org:
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
;; Задание цепочек ключевых слов (переключение между словами клавишами Shift + Right или + Left с курсором на заголовке). "|" отмечает границу, если заголовок в статусе после этого разделителя, то он "выполнен", это влияет на планирование и отображение в Agenda Views:
(setq org-todo-keywords '((sequence "TODO(t)" "START(s)" "MEET(m)" "CALL(c)" "DELEGATED(d)" "WAIT(w)" "|" "CANCEL(r)"  "DONE(f)")))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;; Задание произвольного начертания ключевым словам:
(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "red" :weight bold))
        ("START" . (:foreground "red" :background "white" :weight bold))
        ("MEET" . (:foreground "yellow" :weight bold))
        ("CALL" . (:foreground "lightblue" :weight bold))
        ("DELEGATED" . (:foreground "white" :weight bold))
        ("WAIT" . (:foreground "black" :weight bold))
        ("CANCEL" . (:foreground "violet" :weight bold))
        ("DONE" . (:foreground "green" :weight bold)))
      )
;; Требуется для корректной работы Org Mode:
(global-font-lock-mode 1)
;; Настройка
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(Buffer-menu-use-frame-buffer-list nil)
 '(ecb-options-version "2.40")
 '(jabber-history-size-limit 49741824)
 '(jabber-use-global-history nil)
 '(lj-cache-login-information t)
 '(lj-default-username "rigidus")
 '(org-agenda-files (quote ("/home/rigidus/ORG/agenda.org")))
 '(org-default-notes-file "/home/rigidus/ORG/notes.org")
 '(org-directory "/home/rigidus/ORG/")
 '(org-support-shift-select t))


(add-to-list 'load-path "~/.emacs.d/contrib/emacs") ;; Путь к git
(require 'git)
(require 'git-blame)

;; (define-key mode-specific-map [?a] 'org-agenda)

;; (eval-after-load "org"
;;   '(progn
;;      (define-prefix-command 'org-todo-state-map)

;;      (define-key org-mode-map "\C-cx" 'org-todo-state-map)

;;      (define-key org-todo-state-map "x"
;;        #'(lambda nil (interactive) (org-todo "CANCELLED")))
;;      (define-key org-todo-state-map "d"
;;        #'(lambda nil (interactive) (org-todo "DONE")))
;;      (define-key org-todo-state-map "f"
;;        #'(lambda nil (interactive) (org-todo "DEFERRED")))
;;      (define-key org-todo-state-map "l"
;;        #'(lambda nil (interactive) (org-todo "DELEGATED")))
;;      (define-key org-todo-state-map "s"
;;        #'(lambda nil (interactive) (org-todo "STARTED")))
;;      (define-key org-todo-state-map "w"
;;        #'(lambda nil (interactive) (org-todo "WAITING")))

;;      (define-key org-agenda-mode-map "\C-n" 'next-line)
;;      (define-key org-agenda-keymap "\C-n" 'next-line)
;;      (define-key org-agenda-mode-map "\C-p" 'previous-line)
;;      (define-key org-agenda-keymap "\C-p" 'previous-line)))

;; (require 'remember)

;; (add-hook 'remember-mode-hook 'org-remember-apply-template)

;; (define-key global-map [(control meta ?r)] 'remember)

;; (custom-set-variables
;;  '(org-agenda-files (quote ("~/todo.org")))
;;  '(org-default-notes-file "~/notes.org")
;;  '(org-agenda-ndays 7)
;;  '(org-deadline-warning-days 14)
;;  '(org-agenda-show-all-dates t)
;;  '(org-agenda-skip-deadline-if-done t)
;;  '(org-agenda-skip-scheduled-if-done t)
;;  '(org-agenda-start-on-weekday nil)
;;  '(org-reverse-note-order t)
;;  '(org-fast-tag-selection-single-key (quote expert))
;;  '(org-agenda-custom-commands
;;    (quote (("d" todo "DELEGATED" nil)
;;            ("c" todo "DONE|DEFERRED|CANCELLED" nil)
;;            ("w" todo "WAITING" nil)
;;            ("W" agenda "" ((org-agenda-ndays 21)))
;;            ("A" agenda ""
;;             ((org-agenda-skip-function
;;               (lambda nil
;;                 (org-agenda-skip-entry-if (quote notregexp) "\\=.*\\[#A\\]")))
;;              (org-agenda-ndays 1)
;;              (org-agenda-overriding-header "Today's Priority #A tasks: ")))
;;            ("u" alltodo ""
;;             ((org-agenda-skip-function
;;               (lambda nil
;;                 (org-agenda-skip-entry-if (quote scheduled) (quote deadline)
;;                                           (quote regexp) "<[^>\n]+>")))
;;              (org-agenda-overriding-header "Unscheduled TODO entries: "))))))
;;  '(org-remember-store-without-prompt t)
;;  '(org-remember-templates
;;    (quote ((116 "* TODO %?\n  %u" "~/todo.org" "Tasks")
;;            (110 "* %u %?" "~/notes.org" "Notes"))))
;;  '(remember-annotation-functions (quote (org-remember-annotation)))
;;  '(remember-handler-functions (quote (org-remember-handler))))


;; ;; Bootstrap the Emacs environment to load literate Emacs initialization files.
;; ;; First, establish a root directory from which we can locate the org-mode files we need.
;; (setq dotfiles-dir (file-name-directory (or (buffer-file-name) load-file-name)))
;; ;; Locate the directory that has the org-mode files
;; (let* ((org-dir (expand-file-name
;;                  "lisp" (expand-file-name
;;                          "org-mode" (expand-file-name
;;                                      "src" dotfiles-dir)))))
;;   (add-to-list 'load-path org-dir)
;;   (require 'org-install)
;;   (require 'ob)
;;   )

;; ;; Load all literate org-mode files in this directory (any org-mode files residing there)
;; (mapc #'org-babel-load-file (directory-files dotfiles-dir t "\\.org$"))

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(hl-line ((t (:inherit highlight :background "khaki1")))))
;; ;;; init.el ends here


;; python
;; (require 'pymacs)
;; (pymacs-load "ropemacs" "rope-")

;; python-flymake

(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "epylint" (list local-file))))

  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pylint-init)))

(add-hook 'python-mode-hook 'flymake-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; CUSTOM ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Специальные настройки jabber-аккаунтов
(load-file "~/.emacs.d/jabber-account.el")


(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(put 'overwrite-mode 'disabled nil)

;; http://www.emacswiki.org/emacs/MultipleModes
(require 'multi-mode)

(put 'downcase-region 'disabled nil)

(put 'upcase-region 'disabled nil)

;; Для широкоэкранных сплитов
;; Split Window Preferred Function: Hide Value
;; split-window-sensibly
;; (setq split-width-threshold nil)


;; hilighting for def~ and other constructions
(font-lock-add-keywords 'lisp-mode
                        '(("(\\(\\(define-\\|def~\\|do-\\|with-\\)\\(\\s_\\|\\w\\)*\\)"
                           1 font-lock-keyword-face)))

;; hilightining for def~daoclass-entity name-clasee
(add-hook 'lisp-mode-hook
  (lambda ()
    (font-lock-add-keywords nil
                            '(("(\\(def~daoclass-entity\\)\\s \\(\\(?:\\s_\\|\\sw\\)+\\)"
         (1 font-lock-keyword-face)
         (2 font-lock-type-face))))))

;; indent for def~daoclass-entity as defclass
(put 'def~daoclass-entity 'common-lisp-indent-function
     (get 'defclass 'common-lisp-indent-function))


(setq c-default-style
      '((c-mode . "k&r") (other . "k&r")))


;; ERLANG
;; http://juravskiy.ru/?p=1152

;; Erlang mode
(setq erlang-root-dir "/usr/lib/erlang")
(setq load-path (cons "/usr/lib/erlang/lib/tools-2.6.7/emacs" load-path))
(setq exec-path (cons "/usr/lib/erlang/bin" exec-path))
(setq erlang-man-root-dir "/usr/lib/erlang/man")
(require 'erlang-start)
;; Distel
(add-to-list 'load-path "~/.emacs.d/share/distel/elisp")
(require 'distel)
(distel-setup)
;; Some Erlang customizations
(add-hook 'erlang-mode-hook
(lambda ()
    ;; when starting an Erlang shell in Emacs, with the node
 ;; short name set to vitaliy
(setq inferior-erlang-machine-options '("-sname" "vitaliy"))
;; add Erlang functions to an imenu menu
(imenu-add-to-menubar "imenu")))
;; A number of the erlang-extended-mode key bindings are useful in the
;; shell too
(defconst distel-shell-keys
    '(("\C-\M-i"   erl-complete)
    ("\M-?"      erl-complete)
    ("\M-."      erl-find-source-under-point)
    ("\M-,"      erl-find-source-unwind)
    ("\M-*"      erl-find-source-unwind)
  )
    "Additional keys to bind when in Erlang shell.")

(add-hook 'erlang-shell-mode-hook
	  (lambda ()
	    ;; add some Distel bindings to the Erlang shell
	    (dolist (spec distel-shell-keys)
	      (define-key erlang-shell-mode-map (car spec) (cadr spec)))))


;; PARROT

(load "parrot")
(load "pasm")

(add-to-list 'auto-mode-alist (cons "\\.pasm\\'" 'pasm-mode))

(add-hook 'pasm-mode-hook
          (function (lambda ()
                      (setq indent-tabs-mode nil))))


;;
;; Org Babel
;;
;; (require 'el-get nil t)
;; sudo apt-get install ditaa
(require 'ob-tangle)
(setq org-ditaa-jar-path "/usr/share/ditaa/ditaa.jar")
;; (setq org-plantuml-jar-path "~/java/plantuml.jar")


(defun bh/display-inline-images ()
  (condition-case nil
      (org-display-inline-images)
    (error nil)))
(add-hook 'org-babel-after-execute-hook 'bh/display-inline-images 'append)

;; Make babel results blocks lowercase
(setq org-babel-results-keyword "results")

(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote ((emacs-lisp . t)
         (dot . t)
         (ditaa . t)
         (R . t)
         (python . t)
         (ruby . t)
         (gnuplot . t)
         (clojure . t)
         (sh . t)
         (ledger . t)
         (org . t)
         (plantuml . t)
         (latex . t))))

; Do not prompt to confirm evaluation
; This may be dangerous - make sure you understand the consequences
; of setting this -- see the docstring for details
 (setq org-confirm-babel-evaluate nil)


;; FORMATTING

;; abbrev-mode
;; (add-hook 'php-mode-hook
;; '(lambda ()
;; (define-abbrev php-mode-abbrev-table "ex" "extends")
;; (c-set-style "cc-mode")
;; (c-set-offset 'arglist-close 0)))

;; А также небольшой набор моих предпочтений:
;; - отступ по табулции только если курсор в начале строки;
;; - отображение позиции курсора в строке;
;; - отступ символами табуляции;
;; - отображение размера окна;
;; - ширина табуляции - 4 символа.

(custom-set-variables
;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
 '(c-tab-always-indent nil)
 '(column-number-mode t)
 '(size-indication-mode t)
 '(tab-width 4))
