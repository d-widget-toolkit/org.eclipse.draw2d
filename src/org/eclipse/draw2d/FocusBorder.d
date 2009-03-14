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
module org.eclipse.draw2d.FocusBorder;

import java.lang.all;

import org.eclipse.draw2d.geometry.Insets;
import org.eclipse.draw2d.AbstractBorder;
import org.eclipse.draw2d.IFigure;
import org.eclipse.draw2d.Graphics;
import org.eclipse.draw2d.ColorConstants;

/**
 * A Border that looks like the system's focus rectangle.
 */
public class FocusBorder
    : AbstractBorder
{

/**
 * Constructs a new FocusBorder.
 */
public this() { }

/**
 * @see org.eclipse.draw2d.Border#getInsets(IFigure)
 */
public Insets getInsets(IFigure figure) {
    return new Insets(1);
}

/**
 * @see org.eclipse.draw2d.Border#isOpaque()
 */
public bool isOpaque() {
    return true;
}

/**
 * Paints a focus rectangle.
 * @see org.eclipse.draw2d.Border#paint(IFigure, Graphics, Insets)
 */
public void paint(IFigure figure, Graphics graphics, Insets insets) {
    tempRect.setBounds(getPaintRectangle(figure, insets));
    tempRect.width--;
    tempRect.height--;
    graphics.setForegroundColor(ColorConstants.black);
    graphics.setBackgroundColor(ColorConstants.white);
    graphics.drawFocus(tempRect);
}

}
