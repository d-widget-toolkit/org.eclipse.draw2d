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
module org.eclipse.draw2d.AbsoluteBendpoint;

import java.lang.all;

import org.eclipse.draw2d.geometry.Point;
import org.eclipse.draw2d.Bendpoint;

/**
 * AbsoluteBendpoint is a Bendpoint that defines its location simply as its X and Y
 * coordinates. It is used by bendable {@link Connection Connections}.
 */
public class AbsoluteBendpoint
    : Point
    , Bendpoint
{

/**
 * Creates a new AbsoluteBendpoint at the Point p.
 * @param p The absolute location of the bendpoint
 * @since 2.0
 */
public this(Point p) {
    super(p);
}

/**
 * Creates a new AbsoluteBendpoint at the Point (x,y).
 * @param x The X coordinate
 * @param y The Y coordinate
 * @since 2.0
 */
public this(int x, int y) {
    super(x, y);
}

/**
 * @see org.eclipse.draw2d.Bendpoint#getLocation()
 */
public Point getLocation() {
    return this;
}

}
