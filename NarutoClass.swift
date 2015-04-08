// ---------------------------------------
// Sprite definitions for 'naruto'
// Generated with TexturePacker 3.6.0
//
// http://www.codeandweb.com/texturepacker
// ---------------------------------------

import SpriteKit


class NarutoClass {

    // sprite names
    let NARUTO01               = "naruto01"
    let NARUTO02               = "naruto02"
    let NARUTO03               = "naruto03"
    let NARUTO_ATLASC_NARUTO_1 = "naruto.atlasc/naruto.1"


    // load texture atlas
    let textureAtlas = SKTextureAtlas(named: "naruto")


    // individual texture objects
    func naruto01() -> SKTexture               { return textureAtlas.textureNamed(NARUTO01) }
    func naruto02() -> SKTexture               { return textureAtlas.textureNamed(NARUTO02) }
    func naruto03() -> SKTexture               { return textureAtlas.textureNamed(NARUTO03) }
    func naruto_atlasc_naruto_1() -> SKTexture { return textureAtlas.textureNamed(NARUTO_ATLASC_NARUTO_1) }


    // texture arrays for animations
    func naruto() -> [SKTexture] {
        return [
            naruto01(),
            naruto02(),
            naruto03()
        ]
    }

}
