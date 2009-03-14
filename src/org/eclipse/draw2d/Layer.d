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
module org.eclipse.draw2d.Layer;

import java.lang.all;

import org.eclipse.draw2d.geometry.Point;
import org.eclipse.draw2d.Figure;
import org.eclipse.draw2d.IFigure;
import org.eclipse.draw2d.TreeSearch;


/**
 * A transparent figure intended to be added exclusively to a {@link LayeredPane}, who has
 * the responsibilty of managing its layers.
 */
public class Layer
    : Figure
{

/**
 * Overridden to implement transparent behavior.
 * @see IFigure#containsPoint(int, int)
 *
 */
public bool containsPoint(int x, int y) {
    if (isOpaque())
        return super.containsPoint(x, y);
    Point pt = new Point(x, y);
    translateFromParent(pt);
    for (int i = 0; i < getChildren().size(); i++) {
        IFigure child = cast(IFigure)getChildren().get(i);
        if (child.containsPoint(pt.x, pt.y))
            return true;
    }
    return false;
}

/**
 * Overridden to implement transparency.
 * @see IFigure#findFigureAt(int, int, TreeSearch)
 */
public IFigure findFigureAt(int x, int y, TreeSearch search) {
    if (!isEnabled())
        return null;
    if (isOpaque())
        return super.findFigureAt(x, y, search);

    IFigure f = super.findFigureAt(x, y, search);
    if (f is this)
        return null;
    return f;
}

}
