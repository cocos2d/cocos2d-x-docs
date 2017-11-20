# 使用脚本

## 脚本组件

脚本组件是用来扩展 C++ 节点对象的一种方式，你可以将脚本组件绑定到节点对象上，然后脚本组件就能收到 `onEnter`，`onExit` 和 `update` 事件。

脚本组件支持两种脚本语言 JavaScript 和 Lua，使用的脚本组件应该和绑定脚本的语言类型对应，比如 `ComponentJS` 用来绑定 JavaScript 脚本，`ComponentLua` 用来绑定 Lua 脚本。有了脚本组件，你就可以在 Cocos2d-x 的项目中，很方便的使用脚本进行一些控制。需要注意的是，在一个项目中不能混用脚本组件，也就是说一个项目要么只使用 JavaScript 脚本，要么只使用 Lua 脚本。

使用 Lua 脚本：

{% codetabs name="C++", type="cpp" -%}
// create a Sprite and add a LUA component
auto player = Sprite::create("player.png");

auto luaComponent = ComponentLua::create("player.lua");
player->addComponent(luaComponent);
{%- endcodetabs %}

{% codetabs name="Lua", type="lua" -%}
-- player.lua

local player = {
    onEnter = function(self)
        -- do some things in onEnter
    end,

    onExit = function(self)
        -- do some things in onExit
    end,

    update = function(self)
        -- do some things every frame
    end
}

-- it is needed to return player to let c++ nodes know it
return player
{%- endcodetabs %}

使用 JavaScript 脚本:

{% codetabs name="C++", type="cpp" -%}
// create a Sprite and add a LUA component
auto player = Sprite::create("player.png");

auto jsComponent = ComponentJS::create("player.js");
player->addComponent(jsComponent);
{%- endcodetabs %}

{% codetabs name="JavaScript", type="js" -%}
// player.js
Player = cc.ComponentJS.extend({
    generateProjectile: function (x, y) {
        var projectile = new cc.Sprite("components/Projectile.png", cc.rect(0, 0, 20, 20));
        var scriptComponent = new cc.ComponentJS("src/ComponentTest/projectile.js");
        projectile.addComponent(scriptComponent);
        this.getOwner().getParent().addChild(projectile);

        // set position
        var winSize = cc.director.getVisibleSize();
        var visibleOrigin = cc.director.getVisibleOrigin();
        projectile.setPosition(cc.p(visibleOrigin.x + 20, visibleOrigin.y + winSize.height/2));

        // run action
        var posX = projectile.getPositionX();
        var posY = projectile.getPositionY();
        var offX = x - posX;
        var offY = y - posY;

        if (offX <= 0) {
            return;
        }

        var contentSize = projectile.getContentSize();
        var realX = visibleOrigin.x + winSize.width + contentSize.width/2;
        var ratio = offY / offX;
        var realY = (realX * ratio) + posY;
        var realDest = cc.p(realX, realY);

        var offRealX = realX - posX;
        var offRealY = realY - posY;
        var length = Math.sqrt((offRealX * offRealX) + (offRealY * offRealY));
        var velocity = 960;
        var realMoveDuration = length / velocity;

        projectile.runAction(cc.moveTo(realMoveDuration, realDest));
    },

    onEnter: function() {
        var owner = this.getOwner();
        owner.playerComponent = this;
        cc.eventManager.addListener({
            event: cc.EventListener.TOUCH_ALL_AT_ONCE,
            onTouchesEnded: function (touches, event) {
                var target = event.getCurrentTarget();
                if (target.playerComponent) {
                    var location = touches[0].getLocation();
                    target.playerComponent.generateProjectile(location.x, location.y);
                    jsb.AudioEngine.play2d("pew-pew-lei.wav");
                }
            }
        }, owner);
    }
});
{%- endcodetabs %}

注意，两种组件的使用上，有一个重要的区别。使用 Lua 组件，Lua 脚本最后需要返回 Lua 对象，使用 JavaScript 组件，JavaScript 脚本需要扩展 `cc.ComponentJS`。

更详细用法，请参考 Cocos2d-x 引擎的测试项目：`tests/lua-tests/src/ComponentTest` and `tests/js-tests/src/ComponentTest`。
