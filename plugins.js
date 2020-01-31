window.$docsify.plugins = [
    function (hook, vm) {
        // 页头
        hook.beforeEach(function (content) {
            let url = 'https://github.com/zhcppy/zhcppy.github.io/blob/master/' + vm.route.file;
            let editHtml = '[:memo: Edit Document](' + url + ')\n';
            return editHtml + content + '\n----\n' +'Last modified {docsify-updated}';
        });

        // 页尾
        hook.afterEach(function (html) {
            let footer = [
                '<footer>',
                '<span>&copy;2019-2020 <a href="https://github.com/zhcppy">zhcppy</a> Copyright. </span>',
                '<span>Powered by <a href="https://github.com/docsifyjs/docsify" target="_blank">docsify</a>.</span>',
                '</footer>'
            ].join('');
            return html + footer;
        });
    },
];