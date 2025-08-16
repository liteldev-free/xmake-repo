package("preloader")
    set_description("A patched version of the closed-source PreLoader.")

    add_configs("shared", {description = "Build shared library.", default = true, type = "boolean", readonly = true})

    add_urls("https://github.com/LiteLDev/PreLoader.git", {alias = "original_git"})
    add_urls("https://github.com/LiteLDev/PreLoader/releases/download/$(version)/preloader-$(version)-windows-x64.zip", {alias = "original_tarball"})


    local mod_vers = {
        ["v1.13.0"] = 2
    }

    add_urls("https://github.com/liteldev-free/PreLoader/releases/download/$(version)/preloader-windows-x64.zip", {
        alias = "patched_tarball",
        version = function(version)
            return ("%s-mod.%s"):format(version, mod_vers[tostring(version)])
        end
    })

    -- <= 1.9.2, use the open source version. (legacy)
    add_versions("original_git:v1.0.0", "v1.0.0")
    add_versions("original_git:v1.0.1", "v1.0.1")
    add_versions("original_git:v1.0.2", "v1.0.2")
    add_versions("original_git:v1.0.3", "v1.0.3")
    add_versions("original_git:v1.1.0", "v1.1.0")
    add_versions("original_git:v1.2.0", "v1.2.0")
    add_versions("original_git:v1.3.0", "v1.3.0")
    add_versions("original_git:v1.3.1", "v1.3.1")
    add_versions("original_git:v1.4.0", "v1.4.0")
    add_versions("original_git:v1.4.1", "v1.4.1")
    add_versions("original_git:v1.4.2", "v1.4.2")
    add_versions("original_git:v1.4.3", "v1.4.3")
    add_versions("original_git:v1.5.0", "v1.5.0")
    add_versions("original_git:v1.5.1", "v1.5.1")
    add_versions("original_git:v1.5.2", "v1.5.2")
    add_versions("original_git:v1.6.0", "v1.6.0")
    add_versions("original_git:v1.6.1", "v1.6.1")
    add_versions("original_git:v1.6.2", "v1.6.2")
    add_versions("original_git:v1.6.3", "v1.6.3")
    add_versions("original_git:v1.7.0", "v1.7.0")
    add_versions("original_git:v1.8.0", "v1.8.0")
    add_versions("original_git:v1.9.0", "v1.9.0")
    add_versions("original_git:v1.9.1", "v1.9.1")
    add_versions("original_git:v1.9.2", "v1.9.2")

    -- <= 1.12.0, use the original prebuilt version. (closed-source)
    -- add_versions("original_tarball:v1.10.0", "96e70cad2e3da66093694d355d7a943b0ee3bacb54838c328ff5875684c5668f") -- FIXME: broken package, no includes, no libs.
    add_versions("original_tarball:v1.11.0", "b8732ce24f2d58d6f3b347a28f67f1af5b652e4a092e652996ddd0d96ced7b9d")
    add_versions("original_tarball:v1.12.0", "20d5484c4b76396089d294d8b0373aa56d53cc3c4fdd9b3f3e7705d06b11e811")

    -- >= 1.13.0, use the patched version.
    add_versions("patched_tarball:v1.13.0", "c254df3cad06df9886a1f26fc6eeb3e8263e496e1c3a6ca15d0a43be85fab107")

    on_install("windows|x64", function(package)
        if package:version():le("1.9.2") then
            import("package.tools.xmake").install(package)
        else
            os.cp("*", package:installdir())
        end
    end)

    on_test(function(package)
        assert(package:has_cfuncs("pl_resolve_symbol", {includes = "pl/SymbolProvider.h"}))
    end)
