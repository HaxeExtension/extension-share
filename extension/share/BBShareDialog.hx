package extension.share;

import extension.share.Share;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.geom.Point;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.utils.ByteArray;
import haxe.ds.Option;

using Lambda;

@:access(extension.share.Share)
class BBShareDialog extends Sprite {

	static inline var ENTRY_X_MARGIN = 15.0;
	static inline var ENTRY_Y_MARGIN = 20.0;
	static inline var IMG_SIZE = 55;

	var removedOnAdded : Array<DisplayObject>;

	var titleBar : Sprite;
	var scrollContainer : Sprite;
	var backBtn : Sprite;

	var shareTxt : String;
	var btns : Array<Sprite>;
	var keys : Array<String>;
	var mouseDownPos : Option<Float>;
	var scrolledAmount : Float;
	var scrollSpeed : Float;

	public function new(elems : Array<ShareQueryResult>, shareTxt : String) {

		super();

		removedOnAdded = [];

		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

		titleBar = new Sprite();
		scrollContainer = new Sprite();
		this.shareTxt = shareTxt;
		btns = [];
		keys = [];
		mouseDownPos = None;
		scrolledAmount = 0;
		scrollSpeed = 0;
		var yPos = ENTRY_Y_MARGIN;

		var titleBarH = IMG_SIZE*1.7;
		titleBar.graphics.beginFill(0x282828);
		titleBar.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, titleBarH);
		titleBar.graphics.endFill();
		titleBar.graphics.lineStyle(6, 0x0092CC);
		titleBar.graphics.moveTo(0, titleBarH);
		titleBar.graphics.lineTo(Lib.current.stage.stageWidth, titleBarH);
		titleBar.x = titleBar.y = 0;

		var title = new TextField();
		title.text = "Share";
		title.autoSize = TextFieldAutoSize.LEFT;
		title.selectable = false;
		title.textColor = 0xf0f0f0;
		var format = new TextFormat();
		format.size = 45;
		format.font = "Arial";
		format.align = TextFormatAlign.CENTER;
		format.bold = true;
		title.setTextFormat(format);

		backBtn = new Sprite();

		backBtn.graphics.beginFill(0x282828);
		backBtn.graphics.drawRect(0, 0, titleBar.width*0.2, titleBar.height*0.8);
		backBtn.graphics.endFill();

		backBtn.graphics.lineStyle(1, 0x969696);
		backBtn.graphics.moveTo(backBtn.width-1, 0+10);
		backBtn.graphics.lineTo(backBtn.width-1, backBtn.height-10);

		titleBar.addChild(backBtn);
		backBtn.y = titleBar.height/2 - backBtn.height/2 - 2;

		var cancel = new TextField();
		cancel.text = "Cancel";
		cancel.autoSize = TextFieldAutoSize.LEFT;
		cancel.selectable = false;
		cancel.textColor = 0x087099;
		format = new TextFormat();
		format.size = 35;
		format.bold = true;
		format.font = "Arial";
		cancel.setTextFormat(format);
		backBtn.addChild(cancel);
		cancel.x = backBtn.width/2 - cancel.width/2;
		cancel.y = backBtn.height/2 - cancel.height/2;

		titleBar.addChild(title);
		title.x = titleBar.width/2 - title.width/2;
		title.y = titleBar.height/2 - title.height/2;

		var gfx = this.graphics;
		gfx.lineStyle(0);
		gfx.beginFill(0x000000);

		gfx.drawRect(
			Lib.current.x,
			Lib.current.y,
			Lib.current.stage.stageWidth,
			Lib.current.stage.stageHeight);

		gfx.endFill();

		// First line
		scrollContainer.graphics.lineStyle(1.0, 0x323232);
		scrollContainer.graphics.moveTo(0, yPos);
		scrollContainer.graphics.lineTo(Lib.current.stage.stageWidth, yPos);
		scrollContainer.graphics.lineStyle(0.0);

		for (e in elems) {

			var txt = new TextField();
			txt.text = e.label;
			txt.x = IMG_SIZE + 2*ENTRY_X_MARGIN;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.selectable = false;
			txt.textColor = 0xf0f0f0;

			var format = new TextFormat();
			format.size = 35;
			format.font = "Arial";

			txt.setTextFormat(format);

			txt.y = yPos + txt.getLineMetrics(0).descent;

			var h = txt.height + ENTRY_Y_MARGIN;

			try {

				var bytes = ByteArray.readFile(e.icon);
				var bData = BitmapData.loadFromBytes(bytes);
				var bmp = new Bitmap(bData, true);
				var spr = new Sprite();
				spr.addChild(bmp);

				spr.x = ENTRY_X_MARGIN;
				spr.y = yPos + h/2 - IMG_SIZE/2;
				spr.scaleX = IMG_SIZE / bmp.width;
				spr.scaleY = IMG_SIZE / bmp.height;

				scrollContainer.addChild(spr);

			} catch (d : Dynamic) {

				scrollContainer.graphics.beginFill(0xff0000);
				scrollContainer.graphics.drawRect(ENTRY_X_MARGIN, yPos + h/2 - IMG_SIZE/2, IMG_SIZE, IMG_SIZE);
				scrollContainer.graphics.endFill();

			}

			var btn = new Sprite();
			btn.graphics.beginFill(0x0000ff, 0.2);
			btn.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, h);
			btn.graphics.endFill();
			btn.x = 0;
			btn.y = yPos;
			btns.push(btn);
			keys.push(e.key);
			btn.visible = false;
			scrollContainer.addChild(btn);

			yPos += h;

			scrollContainer.graphics.lineStyle(1.0, 0x323232);
			scrollContainer.graphics.moveTo(0, yPos);
			scrollContainer.graphics.lineTo(Lib.current.stage.stageWidth, yPos);
			scrollContainer.graphics.lineStyle(0.0);

			scrollContainer.addChild(txt);

		}

		scrollContainer.y = titleBar.height-17;

		addChild(scrollContainer);
		addChild(titleBar);

	}

	function onAddedToStage(_) {

		removedOnAdded = [];
		for (i in 0...Lib.current.stage.numChildren) {
			var c = Lib.current.stage.getChildAt(i);
			if (c!=null && c!=this) {
				c.y += 5000;
				removedOnAdded.push(c);
			}
		}

		var evtsObject = this.stage;
		evtsObject.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, 9999);
		evtsObject.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, 9999);
		evtsObject.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, 9999);
		evtsObject.addEventListener(MouseEvent.CLICK, stopPropagation, 9999);

		evtsObject.addEventListener(TouchEvent.TOUCH_TAP, stopPropagation, 9999);
		evtsObject.addEventListener(TouchEvent.TOUCH_BEGIN, stopPropagation, 9999);
		evtsObject.addEventListener(TouchEvent.TOUCH_END, stopPropagation, 9999);
		evtsObject.addEventListener(TouchEvent.TOUCH_MOVE, stopPropagation, 9999);

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		backBtn.addEventListener(MouseEvent.CLICK, exit);

	}

	function onRemovedFromStage(_) {

		var evtsObject = this.stage;
		evtsObject.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		evtsObject.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		evtsObject.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		evtsObject.removeEventListener(MouseEvent.CLICK, stopPropagation);

		evtsObject.removeEventListener(TouchEvent.TOUCH_TAP, stopPropagation);
		evtsObject.removeEventListener(TouchEvent.TOUCH_BEGIN, stopPropagation);
		evtsObject.removeEventListener(TouchEvent.TOUCH_END, stopPropagation);
		evtsObject.removeEventListener(TouchEvent.TOUCH_MOVE, stopPropagation);

		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		backBtn.removeEventListener(MouseEvent.CLICK, exit);

		for (c in removedOnAdded) {
			c.y -= 5000;
		}

	}

	function exit(e : MouseEvent) {

		if (e!=null) {
			e.stopImmediatePropagation();
			e.stopPropagation();
		}
		parent.removeChild(this);

		Share.__onBBShareDialogExit();

	}

	function stopPropagation(e : Event) {

		e.stopImmediatePropagation();
		e.stopPropagation();

	}

	function onMouseDown(m : MouseEvent) {

		m.stopImmediatePropagation();
		m.stopPropagation();
		var p = new Point(m.stageX, m.stageY);
		var pTitleBar = new Point(0, titleBar.height);
		pTitleBar = titleBar.globalToLocal(pTitleBar);
		if (m.stageY<pTitleBar.y) {
			return;
		}
		mouseDownPos = Some(m.stageY);
		scrolledAmount = 0;

		this.globalToLocal(p);

		for (i in 0...btns.length) {
			var b = btns[i];
			if (getObjectsUnderPoint(p).has(b)) {
				b.visible = true;
			}
		}

	}

	function onMouseUp(m : MouseEvent) {

		m.stopImmediatePropagation();
		m.stopPropagation();
		mouseDownPos = None;
		var p = new Point(m.stageX, m.stageY);
		this.globalToLocal(p);

		for (i in 0...btns.length) {
			var b = btns[i];
			if (getObjectsUnderPoint(p).has(b) && b.visible) {
				Share.bbShare(keys[i], shareTxt);
				exit(null);
			}
			b.visible = false;
		}

	}

	function onMouseMove(m : MouseEvent) {

		m.stopImmediatePropagation();
		m.stopPropagation();
		switch (mouseDownPos) {
			case Some(oldPos): {
				var moved = oldPos - m.stageY;
				scrollSpeed = Math.min(moved, 999.0);
				scrolledAmount += Math.abs(moved);
				mouseDownPos = Some(m.stageY);
				if (scrolledAmount>10 &&
					scrollContainer.height > Lib.current.stage.stageHeight-titleBar.height) {

					for (b in btns) {
						b.visible = false;
					}
					scrollContainer.y -= moved;

				}
			}
			case None: {}
		}

	}

	function onEnterFrame(_) {

		var bottomBound = Lib.current.y + Lib.current.stage.stageHeight + titleBar.height;

		switch (mouseDownPos) {
			case Some(pos): {}
			case None: {
				if (scrollContainer.y>titleBar.height-17) {

					var diff = titleBar.height-17 - scrollContainer.y;
					scrollSpeed = -diff/4.0;

				} else if (scrollContainer.y + scrollContainer.height < bottomBound) {

					var diff = scrollContainer.y + scrollContainer.height + 16 -
						bottomBound;
					scrollSpeed = diff/4.0;

				} else {

					scrollSpeed /= 1.3;

				}
				scrollContainer.y -= scrollSpeed;
			}
		}

	}

}
