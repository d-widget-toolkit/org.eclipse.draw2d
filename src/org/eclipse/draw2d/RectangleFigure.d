/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module org.eclipse.draw2d.RectangleFigure;

import java.lang.all;

import org.eclipse.draw2d.geometry.Rectangle;
import org.eclipse.draw2d.Shape;
import org.eclipse.draw2d.Graphics;

/**
 * Draws a rectangle whose size is determined by the bounds set to it.
 */
public class RectangleFigure : Shape {

/**
 * Creates a RectangleFigure.
 */
public this() { }

/**
 * @see Shape#fillShape(Graphics)
 */
protected void fillShape(Graphics graphics) {
    graphics.fillRectangle(getBounds());
}

/**
 * @see Shape#outlineShape(Graphics)
 */
protected void outlineShape(Graphics graphics) {
    Rectangle r = getBounds();
    int x = r.x + lineWidth / 2;
    int y = r.y + lineWidth / 2;
    int w = r.width - Math.max(1, lineWidth);
    int h = r.height - Math.max(1, lineWidth);
    graphics.drawRectangle(x, y, w, h);
}

}
