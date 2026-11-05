(setq url-timeout 10)

(package-refresh-contents t)

;; Add the folder containing your script
(add-to-list 'load-path "~/.emacs.d/lisp/")

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;; Display the number lines
;;(global- 1)

(setq display-line-numbers-type 'absolute)
(global-display-line-numbers-mode t)
(column-number-mode t)


;; MELPA PAGKAGES				     
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;;ELPA PACKAGES
(require 'package)
(add-to-list 'package-archives '("elpa"  . "https://elpa.gnu.org/packages/") t)

;; Enable electric-pair-mode for automatic insertion of matching parentheses
(electric-pair-mode 1)

;; Activating windmove to move between the windows: Shift + arrow key 
(windmove-default-keybindings) 

;; Indentation
(setq-default tab-width 8)
(setq-default c-default-style "linux")

(setq backward-delete-char-untabify-method 'nil)

;; Fonts
;;(set-frame-parameter nil 'font "Source Code Pro Semibold-13")
 (set-frame-parameter nil 'font "JetBrains Mono SemiBold-13")
;; (set-frame-parameter nil 'font "JetBrains Mono ExtraLight-13")


(global-font-lock-mode 1)

;; Checking where Im running emacs
(if (daemonp)
    (message "[CONFIG-INFO] Loading in the daemon!")
  (message "[CONFIG-INFO] Loading in regular Emacs!"))


;;Emacs Transparent

;; To make emacs transparent
(set-frame-parameter nil 'alpha-background 55)
(add-to-list 'default-frame-alist '(alpha-background . 55))

;; Ensure new frames created by the emacsclient also inherit the transparency setting
(defun set-frame-transparency (frame)
(set-frame-parameter frame 'alpha-background 55))

(add-hook 'after-make-frame-functions 'set-frame-transparency)


;; --------------------------------------------------------------------------
;; Key bindings config


;; To compile code or to run commands
(global-set-key [f5] 'compile)

;; Shell command to be saved
(defvar previous-shell-command nil
  "Variable to store the previous shell command.")

(defun my/async-shell-command-with-previous ()
  "Run `async-shell-command` with the previously used command, if any."
  (interactive)
  (let ((command (read-shell-command "Shell command: " previous-shell-command)))
    (setq previous-shell-command command)
    (async-shell-command command)))


;; To run commands with input and output streams
(global-set-key [f6] 'my/async-shell-command-with-previous)


;; dired
;; To add a new file to the current listed direcotry 
(defun my/dired-add-file-here ()
  "Add a new file in the current directory in Dired mode."
  (interactive)
  (let ((dir (dired-current-directory)))
    (find-file (expand-file-name (read-string "New file name: " nil nil "new_file") dir))))

(global-set-key (kbd "C-+") 'my/dired-add-file-here)


(defun my-rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-,") 'my-rc/duplicate-line)


(defun my/open-init-file ()
  "Open my init.el quickly."
  (interactive)
  (find-file "~/.emacs"))

;; -------------------------------------------------------------------------------------------
;; Native Packages

;; https://www.gnu.org/software/emacs/manual/html_mono/ido.html#Overview
(require 'ido)
(ido-mode t)



;; Doxygen
;; https://github.com/pniedzielski/doxymacs
(use-package doxymacs
  :vc (:url "https://github.com/pniedzielski/doxymacs.git"
            :rev :newest
            :lisp-dir "lisp/")
  :hook (c-mode-common-hook . doxymacs-mode)
  :bind (:map c-mode-base-map
              ;; Lookup documentation for the symbol at point.
              ("C-c d ?" . doxymacs-lookup)
              ;; Rescan your Doxygen tags file.
              ("C-c d r" . doxymacs-rescan-tags)
              ;; Prompt you for a Doxygen command to enter, and its
              ;; arguments.
              ("C-c d RET" . doxymacs-insert-command)
              ;; Insert a Doxygen comment for the next function.
              ("C-c d f" . doxymacs-insert-function-comment)
              ;; Insert a Doxygen comment for the current file.
              ("C-c d i" . doxymacs-insert-file-comment)
              ;; Insert a Doxygen comment for the current member.
              ("C-c d ;" . doxymacs-insert-member-comment)
              ;; Insert a blank multi-line Doxygen comment.
              ("C-c d m" . doxymacs-insert-blank-multiline-comment)
              ;; Insert a blank single-line Doxygen comment.
              ("C-c d s" . doxymacs-insert-blank-singleline-comment)
              ;; Insert a grouping comments around the current region.
              ("C-c d @" . doxymacs-insert-grouping-comments))
  :custom
    ;; Configure source code <-> Doxygen tag file <-> Doxygen HTML
    ;; documentation mapping:
    ;;   - Files in /home/me/project/foo/ have their tag file at
    ;;     http://someplace.com/doc/foo/foo.xml, and HTML documentation
    ;;     at http://someplace.com/doc/foo/.
    ;;   - Files in /home/me/project/bar/ have their tag file at
    ;;     ~/project/bar/doc/bar.xml, and HTML documentation at
    ;;     file:///home/me/project/bar/doc/.
    ;; This must be configured for Doxymacs to function!
    (doxymacs-doxygen-dirs
     '(("^/home/hespinozas/Documentos/miCarpeta/projects/foo"
        "http://someplace.com/doc/foo/foo.xml"
         "http://someplace.com/doc/foo/")
       ("^/home/me/project/bar/"
        "~/project/bar/doc/bar.xml"
        "file:///home//project/bar/doc/"))))






;; https://company-mode.github.io/
(use-package company
  :hook (prog-mode . company-mode)
  :bind
  (:map company-active-map
        ("<tab>" . company-complete-selection)
        ("<escape>" . company-abort))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)
  (company-tooltip-limit 20)
  :ensure t
  :config
  (company-mode 1)
  )


;; https://github.com/AndreaCrotti/yasnippet-snippets
(use-package yasnippet-snippets
  :ensure t)
(require 'yasnippet)
(setq yas-snippet-dirs '("~/.emacs.d/snippets")) ; Path to your custom templates
(yas-global-mode 1)       


;; https://github.com/bbatsov/super-save
(use-package super-save
  :ensure t
  :config
  (super-save-mode 1)
  (setq super-save-auto-save-when-idle t)) ;; Save when idle


;; https://github.com/joaotavora/yasnippet
(use-package yasnippet
  :ensure t
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))


;; https://github.com/magnars/multiple-cursors.el
(use-package multiple-cursors
  :ensure t
  ;; When you want to add multiple cursors not based on continuous lines,
  ;; but based on keywords in the buffer, use:
  ;; `C-g` To remove all the cursos
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(ef-winter))
 '(custom-safe-themes
   '("e13beeb34b932f309fb2c360a04a460821ca99fe58f69e65557d6c1b10ba18c7"
     "f053f92735d6d238461da8512b9c071a5ce3b9d972501f7a5e6682a90bf29725"
     "088cd6f894494ac3d4ff67b794467c2aa1e3713453805b93a8bcb2d72a0d1b53"
     "816e33b578954abb2ec70b9b57364d837205301f819c84cbd8298a76bbf69066"
     "bc877ca134b38b7445bbab8526b97bfb7538ba082dd18cf5911f4fe634d21c63"
     "1f292969fc19ba45fbc6542ed54e58ab5ad3dbe41b70d8cb2d1f85c22d07e518"
     "7c3d62a64bafb2cc95cd2de70f7e4446de85e40098ad314ba2291fc07501b70c"
     "4732feaaeab14f39b62cb922096749d0e9c5d561f6192e13dc2a3d8729d1fd4b"
     "f2f42f0b7c53736840fc3ff5751235e3b87cc535b04ddaf3423e2926548bfbb4"
     "d377dfcca68cbe7044425f87de873a0007a96187c1cbefa2b9ec360f2108ad78"
     "13b88366eb891d6496e06c72c7ef55943c72095bcc93f46bb67473adeb88fcd1"
     "8f787ed2d75bb7073796c00f7e1033d6e92f39314939446dd2d8e95cbc168422"
     "e558acb85628028d35a1a4f37af738aa35062f26a6f8bea535048cca1427b4d2"
     "2dd2fe7575d76094652d9e04de604db1cd1cdf1582e1494bc646b2a6e402afb0"
     "4f1641913dd7705f03f5b3271a570d5b4289bdd974665b8919164f2e43799fbd"
     "f2b09aa814c194d1e491448f8975c185c14f7d901958dd760b4e667d8daed1d6"
     "eeaa104f99d641c8be210d3555eba029756d5dc7a2f9a342af526045c3a82c60"
     "725195e919c94667dfbe186161d63f11799b93d74e846ec1404900f34d320c79"
     "068372892e8e4133677252fbf46839dcaf34efd211d4d202148e0371118175f9"
     "8e8acbea18dbf51b41a09e7fc789f8af666b2ca8c099a268b5275bfc4541a5ff"
     "cc8e6619a14298073d987046081c541b8b3854a6446497bdc254c3fad065cc30"
     "374ba7157893123caaf89df302153ce57c16e4ad4b51f127b9306b80560a6a2d"
     "5e2b82d4d3c794cdc1d46fe2a6ca54efed4df7caaefa3e80d6f566a9a24bc881"
     "854b81231db83bc217b0c8671f23ec92163a96b28f045ff879bba738a9ed88bb"
     "2b0531a540f4b51e524f551ed7374099f9d743b4de458ade0c52ba18ee6bfe46"
     "f38f24d7468df32f8945a0572c856223f8351b8ea050b717ce36b0051399e3ad"
     "f76e34f676ac1fbce608c5f38033c35e370509619b9a3acd02a518ef58b01107"
     "998bc02f2e52205ad06df88a14d53168aef1ec1bbcc6fe2b0cd15fed8e5c8dae"
     "1d18bef9d0e1b7f30a3290c48fdc52465bdca62564e404c1019bb1fcc8cb0c27"
     "a8c1252f9844caf313a2315ecf1e8ef4d92495c9f2067d875bb1c783b08719ad"
     "ec717a4698b3fa398eb7f8214adba47d4f51bab42c3925ba0ffe3abc5f82712a"
     "bb18b6d5982beeb76a37ced9211e972f84e8e76af9579456aa8cef794ae0bcb9"
     "b89b6d95670712b8742f4391416483a29d4315323a218600590160e132c70ec8"
     "de8c7f41a226981177f0aa5c9d5bad1decf8569d2c168cc4ec6d4493e4356bd4"
     "b8719ba8ddfa912c98d876d5cc530c13bd6589e34b617093848e492aabe2a2dd"
     "953a4391d91a93ac734777a53001d1b514c22c4b7233c932ae029a5b01cdf3f7"
     "8bffaccb8930a5e9e519485c0ed7e13cf4af4c86cda1e62c6d0bc597329776e9"
     "acd363510d3e4b638db178783bde3d4492574c0f5c889f845251949f43567d16"
     "7d9c94cc1edddc6162c89c85bbdeed14e5b93a21ec83a55710d6a501bf295cf7"
     "333b0cc0f985744d97beebf433542bb93b314b331117aa57e91103dbec9c29fe"
     "5cb84685a211fb46e47ca355dc91e52adf0c185dc0603cfe27c63855f200dd1f"
     "0dd83cb583518e6a20cd7881e4d2251c80c1141b50dc29fbe13198e62f3620f6"
     "38b43b865e2be4fe80a53d945218318d0075c5e01ddf102e9bec6e90d57e2134"
     "dd29357aa912765ab306531281880b7cb0ee73a0106b11f47530cc84223188fb"
     "e0fbe5caa6e602975e59cdd381c9773a670a864dd7bb7bf2345414856148098b"
     "7c0179ef765b9bf1d79612235236d29eebcaca9b4a287ff802959ed20db154b6"
     "05f1ee9db2c66cd715ab6d36ff949386c47dfff91a7df1f203d015b3ea304dbb"
     "21d2bf8d4d1df4859ff94422b5e41f6f2eeff14dd12f01428fa3cb4cb50ea0fb"
     "f64189544da6f16bab285747d04a92bd57c7e7813d8c24c30f382f087d460a33"
     "0c83e0b50946e39e237769ad368a08f2cd1c854ccbcd1a01d39fdce4d6f86478"
     "fc3e49bdacf0be94db17e480803d4a59d2ea6501d28ac4183b89085a136033bd"
     "3061706fa92759264751c64950df09b285e3a2d3a9db771e99bcbb2f9b470037"
     "2f7fa7a92119d9ed63703d12723937e8ba87b6f3876c33d237619ccbd60c96b9"
     "f253a920e076213277eb4cbbdf3ef2062e018016018a941df6931b995c6ff6f6"
     "42a6583a45e0f413e3197907aa5acca3293ef33b4d3b388f54fa44435a494739"
     "be0d9f0e72a4ebc4a59c382168921b082b4dc15844bdaf1353c08157806b3321"
     "19d62171e83f2d4d6f7c31fc0a6f437e8cec4543234f0548bad5d49be8e344cd"
     "c07f072a88bed384e51833e09948a8ab7ca88ad0e8b5352334de6d80e502da8c"
     "f6ea954a9544b0174a876d195387f444da441535ee88c7fb0fc346af08b0d228"
     "4b88b7ca61eb48bb22e2a4b589be66ba31ba805860db9ed51b4c484f3ef612a7"
     "c3c135e69890de6a85ebf791017d458d3deb3954f81dcb7ac8c430e1620bb0f1"
     "dfb1c8b5bfa040b042b4ef660d0aab48ef2e89ee719a1f24a4629a0c5ed769e8"
     "02d422e5b99f54bd4516d4157060b874d14552fe613ea7047c4a5cfa1288cf4f"
     "7de64ff2bb2f94d7679a7e9019e23c3bf1a6a04ba54341c36e7cf2d2e56e2bcc"
     "22a0d47fe2e6159e2f15449fcb90bbf2fe1940b185ff143995cc604ead1ea171"
     "b5fd9c7429d52190235f2383e47d340d7ff769f141cd8f9e7a4629a81abc6b19"
     "dd4582661a1c6b865a33b89312c97a13a3885dc95992e2e5fc57456b4c545176"
     "f4d1b183465f2d29b7a2e9dbe87ccc20598e79738e5d29fc52ec8fb8c576fcfd"
     "4990532659bb6a285fee01ede3dfa1b1bdf302c5c3c8de9fad9b6bc63a9252f7"
     "fffef514346b2a43900e1c7ea2bc7d84cbdd4aa66c1b51946aade4b8d343b55a"
     "e622620e5f31216fd71e492fc1476e1fe7c21b8dc5811bf9e640c4b1fd6cfac1"
     "8d3ef5ff6273f2a552152c7febc40eabca26bae05bd12bc85062e2dc224cde9a"
     "d481904809c509641a1a1f1b1eb80b94c58c210145effc2631c1a7f2e4a2fdf4"
     "b754d3a03c34cfba9ad7991380d26984ebd0761925773530e24d8dd8b6894738"
     "5c7720c63b729140ed88cf35413f36c728ab7c70f8cd8422d9ee1cedeb618de5"
     "e8ceeba381ba723b59a9abc4961f41583112fc7dc0e886d9fc36fa1dc37b4079"
     "93011fe35859772a6766df8a4be817add8bfe105246173206478a0706f88b33d"
     "d97ac0baa0b67be4f7523795621ea5096939a47e8b46378f79e78846e0e4ad3d"
     "0f1341c0096825b1e5d8f2ed90996025a0d013a0978677956a9e61408fcd2c77"
     "0d2c5679b6d087686dcfd4d7e57ed8e8aedcccc7f1a478cd69704c02e4ee36fe"
     "5c8a1b64431e03387348270f50470f64e28dfae0084d33108c33a81c1e126ad6"
     "4594d6b9753691142f02e67b8eb0fda7d12f6cc9f1299a49b819312d6addad1d"
     "f1e8339b04aef8f145dd4782d03499d9d716fdc0361319411ac2efc603249326"
     "df6dfd55673f40364b1970440f0b0cb8ba7149282cf415b81aaad2d98b0f0290"
     "6963de2ec3f8313bb95505f96bf0cf2025e7b07cefdb93e3d2e348720d401425"
     "9b9d7a851a8e26f294e778e02c8df25c8a3b15170e6f9fd6965ac5f2544ef2a9"
     "599f72b66933ea8ba6fce3ae9e5e0b4e00311c2cbf01a6f46ac789227803dd96"
     "13096a9a6e75c7330c1bc500f30a8f4407bd618431c94aeab55c9855731a95e1"
     "7ec8fd456c0c117c99e3a3b16aaf09ed3fb91879f6601b1ea0eeaee9c6def5d9"
     "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8"
     "a6920ee8b55c441ada9a19a44e9048be3bfb1338d06fc41bce3819ac22e4b5a1"
     "2ab8cb6d21d3aa5b821fa638c118892049796d693d1e6cd88cb0d3d7c3ed07fc"
     "9e5e0ff3a81344c9b1e6bfc9b3dcf9b96d5ec6a60d8de6d4c762ee9e2121dfb2"
     "e14289199861a5db890065fdc5f3d3c22c5bac607e0dbce7f35ce60e6b55fc52"
     "e4a702e262c3e3501dfe25091621fe12cd63c7845221687e36a79e17cf3a67e0"
     "e8bd9bbf6506afca133125b0be48b1f033b1c8647c628652ab7a2fe065c10ef0"
     "10e330880269244ae45ae9e02fe6f55766da9e15036e7c7f07d7ce228195deb5"
     "2f8af2a3a2fae6b6ea254e7aab6f3a8b5c936428b67869cef647c5f8e7985877"
     "b7a09eb77a1e9b98cafba8ef1bd58871f91958538f6671b22976ea38c2580755"
     "a9eeab09d61fef94084a95f82557e147d9630fbbb82a837f971f83e66e21e5ad"
     "e1df746a4fa8ab920aafb96c39cd0ab0f1bac558eff34532f453bd32c687b9d6"
     "5244ba0273a952a536e07abaad1fdf7c90d7ebb3647f36269c23bfd1cf20b0b8"
     "83550d0386203f010fa42ad1af064a766cfec06fc2f42eb4f2d89ab646f3ac01"
     "720838034f1dd3b3da66f6bd4d053ee67c93a747b219d1c546c41c4e425daf93"
     "166a2faa9dc5b5b3359f7a31a09127ebf7a7926562710367086fcc8fc72145da"
     "456697e914823ee45365b843c89fbc79191fdbaff471b29aad9dcbe0ee1d5641"
     "ff24d14f5f7d355f47d53fd016565ed128bf3af30eb7ce8cae307ee4fe7f3fd0"
     "b99ff6bfa13f0273ff8d0d0fd17cc44fab71dfdc293c7a8528280e690f084ef0"
     "7771c8496c10162220af0ca7b7e61459cb42d18c35ce272a63461c0fc1336015"
     "2d2bdc418a7811a9652729894b3b74679bd8652959e09f1e046081d722d1987e"
     "0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1"
     "d12b1d9b0498280f60e5ec92e5ecec4b5db5370d05e787bc7cc49eae6fb07bc0"
     "9d5124bef86c2348d7d4774ca384ae7b6027ff7f6eb3c401378e298ce605f83a"
     "3613617b9953c22fe46ef2b593a2e5bc79ef3cc88770602e7e569bbd71de113b"
     "c9d837f562685309358d8dc7fccb371ed507c0ae19cf3c9ae67875db0c038632"
     "70c88c01b0b5fde9ecf3bb23d542acba45bb4c5ae0c1330b965def2b6ce6fac3"
     "8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098"
     "87fa3605a6501f9b90d337ed4d832213155e3a2e36a512984f83e847102a42f4"
     "1781e8bccbd8869472c09b744899ff4174d23e4f7517b8a6c721100288311fa5"
     "e7820b899036ae7e966dcaaec29fd6b87aef253748b7de09e74fdc54407a7a02"
     "de8f2d8b64627535871495d6fe65b7d0070c4a1eb51550ce258cd240ff9394b0"
     "0ef0c3e24c8f704430e2b2f473101c08fb8bab93d09a80dbc2ea2dbb799aa861"
     "138ed99a323c1b93c52f4b3726caf2bc634b79a76fa63a3d3aff76394db5f28f"
     "28f3ac0f5fade64dc7e27abe9d32e7d85576c40940977e8e319f25055d3a28b7"
     "2493d0ad0bb94bd2ad297a6d76288751a532fd6d8d6af694ac14008caa6b7fa2"
     "967c23e9ba179b80560774419f081df22e7674aac23c5c550b817e4a1ce7d058"
     "8325ce8887001cf97589b3460ee88fd3344a290a815ec248945de6d223b7b01f"
     "6dcc66a60dce37a5817d46e7b1f838ac5d95a79061119adeb7c04c7ae9f511d0"
     default))
 '(gnus-logo-color-style 'storm)
 '(package-selected-packages
   '(auctex autotetris-mode chess company company-posframe compile-angel
	    dashboard diff-hl diredfl doxymacs folio-theme
	    gruber-darker-theme magit-todos multiple-cursors pacmacs
	    python rainbow-delimiters rust-mode smex super-save
	    tetris-60 yasnippet-snippets))
 '(package-vc-selected-packages
   '((doxymacs :url "https://github.com/pniedzielski/doxymacs.git"
	       :lisp-dir "lisp/")))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(scroll-bar ((t (:background "#000000" :foreground "#646464")))))


(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)
  :ensure t)

;; https://github.com/magit/magit/tree/2ed93504778c9ec2b8f56665cbdeae348146fbf7
(use-package magit
  :ensure t)

;; https://github.com/alphapapa/magit-todos/tree/debb77b3589f2d83c8b43706edc1f8f90bf1ad91
(use-package magit-todos
  :ensure t
  :after magit
  :config (magit-todos-mode 1))



;; Ensure Emacs loads the most recent byte-compiled files.
(setq load-prefer-newer t)

(use-package compile-angel
  :demand t
  :config
  ;; Set `compile-angel-verbose' to nil to disable compile-angel messages.
  ;; (When set to nil, compile-angel won't show which file is being compiled.)
  (setq compile-angel-verbose t)

  ;; The following directive prevents compile-angel from compiling your init
  ;; files. If you choose to remove this push to `compile-angel-excluded-path-suffixes'
  ;; and compile your pre/post-init files, ensure you understand the
  ;; implications and thoroughly test your code. For example, if you're using
  ;; the `use-package' macro, you'll need to explicitly add:
  ;; (eval-when-compile (require 'use-package))
  ;; at the top of your init file.
  (push "/init.el" compile-angel-excluded-path-suffixes)
  (push "/early-init.el" compile-angel-excluded-path-suffixes)

  ;; Uncomment the line below to compile automatically when an Elisp file is saved
  ;; (add-hook 'emacs-lisp-mode-hook #'compile-angel-on-save-local-mode)

  ;; A global mode that compiles .el files when they are loaded
  ;; using `load' or `require'.
  (compile-angel-on-load-mode 1))


;; Rust mini IDE

;; C-c C-c C-u rust-compile
;; C-c C-c C-k rust-check
;; C-c C-c C-t rust-test
;; C-c C-c C-r rust-run
(use-package rust-mode
  :ensure t)
