window.$docsify.plugins = [
    function (hook, vm) {
        hook.beforeEach(function (content) {
            let url = 'https://github.com/zhcppy/zhcppy.github.io/blob/master/' + vm.route.file;
            let editHtml = '[:memo: Edit Document](' + url + ')\n';
            return editHtml + content + '\n----\n' +'Last modified {docsify-updated}';
        })
    },
    function (hook) {
        let footer = [
            '<footer>',
            '<span>&copy;2019-2020 <a href="https://github.com/zhcppy">zhcppy</a> Copyright. </span>',
            '<span>Powered by <a href="https://github.com/docsifyjs/docsify" target="_blank">docsify</a>.</span>',
            '</footer>'
        ].join('');

        hook.afterEach(function (html) {
            return html + footer;
        });
    }
];