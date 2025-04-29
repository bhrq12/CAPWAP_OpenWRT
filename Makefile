include $(TOPDIR)/rules.mk

PKG_NAME:=CAPWAP_OpenWRT
PKG_VERSION:=1.0.0
PKG_RELEASE:=1
PKG_LICENSE:=GPL-2.0
PKG_SOURCE_URL:=https://github.com/bhrq12/CAPWAP_OpenWRT
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  TITLE:=CAPWAP implementation for OpenWRT
  DEPENDS:=+libopenssl +libpthread
endef

define Package/$(PKG_NAME)/description
  This package provides an implementation of the CAPWAP protocol for OpenWRT.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./* $(PKG_BUILD_DIR)/
endef

define Build/Configure
	# No configure script is necessary for this package
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include" \
		LDFLAGS="$(TARGET_LDFLAGS) -L$(STAGING_DIR)/usr/lib" \
		all
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/AC $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/WTP $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/config.ac $(1)/etc/config/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/config.wtp $(1)/etc/config/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/INSTALL $(1)/etc/init.d/capwap
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
