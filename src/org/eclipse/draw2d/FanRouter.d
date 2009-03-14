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
module org.eclipse.draw2d.FanRouter;

import java.lang.all;

import org.eclipse.draw2d.geometry.Point;
import org.eclipse.draw2d.geometry.PointList;
import org.eclipse.draw2d.geometry.Ray;
import org.eclipse.draw2d.AutomaticRouter;
import org.eclipse.draw2d.PositionConstants;

/**
 * Automatic router that spreads its {@link Connection Connections} in a fan-like fashion
 * upon collision.
 */
public class FanRouter
    : AutomaticRouter
{

private int separation = 10;

/**
 * Returns the separation in pixels between fanned connections.
 *
 * @return the separation
 * @since 2.0
 */
public int getSeparation() {
    return separation;
}

/**
 * Modifies a given PointList that collides with some other PointList.  The given
 * <i>index</i> indicates that this it the i<sup>th</sup> PointList in a group of
 * colliding points.
 *
 * @param points the colliding points
 * @param index the index
 */
protected void handleCollision(PointList points, int index) {
    Point start = points.getFirstPoint();
    Point end = points.getLastPoint();

    if (start.opEquals(end))
        return;

    Point midPoint = new Point((end.x + start.x) / 2, (end.y + start.y) / 2);
    int position = end.getPosition(start);
    Ray ray;
    if (position is PositionConstants.SOUTH || position is PositionConstants.EAST)
        ray = new Ray(start, end);
    else
        ray = new Ray(end, start);
    double length = ray.length();

    double xSeparation = separation * ray.x / length;
    double ySeparation = separation * ray.y / length;

    Point bendPoint;

    if (index % 2 is 0) {
        bendPoint = new Point(
            midPoint.x + (index / 2) * (-1 * ySeparation),
            midPoint.y + (index / 2) * xSeparation);
    } else {
        bendPoint = new Point(
            midPoint.x + (index / 2) * ySeparation,
            midPoint.y + (index / 2) * (-1 * xSeparation));
    }
    if (!bendPoint.opEquals(midPoint))
        points.insertPoint(bendPoint, 1);
}

/**
 * Sets the colliding {@link Connection Connection's} separation in pixels.
 *
 * @param value the separation
 * @since 2.0
 */
public void setSeparation(int value) {
    separation = value;
}

}
