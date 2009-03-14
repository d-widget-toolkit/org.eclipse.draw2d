/*******************************************************************************
 * Copyright (c) 2005 IBM Corporation and others.
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
module org.eclipse.draw2d.text.FlowAdapter;

import java.lang.all;

import org.eclipse.draw2d.IFigure;
import org.eclipse.draw2d.geometry.Dimension;
import org.eclipse.draw2d.geometry.Rectangle;
import org.eclipse.draw2d.text.FlowFigure;
import org.eclipse.draw2d.text.BidiProcessor;
import org.eclipse.draw2d.text.FlowFigureLayout;
import org.eclipse.draw2d.text.FlowContext;
import org.eclipse.draw2d.text.ContentBox;
import org.eclipse.draw2d.text.BidiInfo;
import org.eclipse.draw2d.text.BidiChars;


/**
 * Adapts non-flow figures for use within a parent hierarchy requiring flow figures.
 * Normal draw2d figures can be added as children.  If a normal LayoutManager is set, the
 * children will be positioned by that layout manager.  The size of this figure within
 * the flow will be determined by its preferred size.
 * <p>
 * WARNING: This class is not intended to be subclassed by clients.
 *
 * @author Pratik Shah
 * @since 3.1
 */
public class FlowAdapter
    : FlowFigure
{

private FlowContext context;
private FigureBox box;

public this(){
    box = new FigureBox();
}
/**
 * This FlowFigure contributes an Object Replacement Character.
 * @see FlowFigure#contributeBidi(BidiProcessor)
 */
protected void contributeBidi(BidiProcessor proc) {
    box.setBidiLevel(-1);
    // contributes a single object replacement char
    proc.add(this, BidiChars.OBJ);
}

/**
 * @return <code>null</code>
 * @see org.eclipse.draw2d.text.FlowFigure#createDefaultFlowLayout()
 */
protected FlowFigureLayout createDefaultFlowLayout() {
    return null;
}

/**
 * Sizes the content box to be big enough to display all figures.  Wraps to the next line
 * if there is not enough room on the current one.
 * @see org.eclipse.draw2d.Figure#layout()
 */
protected void layout() {
    int wHint = context.getRemainingLineWidth();
    if (wHint is Integer.MAX_VALUE)
        wHint = -1;
    Dimension prefSize = getPreferredSize(wHint, -1);
    if (context.isCurrentLineOccupied()
            && prefSize.width > context.getRemainingLineWidth()) {
        context.endLine();
        prefSize = getPreferredSize(context.getRemainingLineWidth(), -1);
    }
    box.setSize(prefSize);
    context.addToCurrentLine(box);
}

/**
 * Updates the bounds of this figure to match that of its content box, and lays out this
 * figure's children.
 * @see FlowFigure#postValidate()
 */
public void postValidate() {
    setBounds(new Rectangle(box.getX(), box.getBaseline() - box.ascent,
            box.width, box.ascent));
    super.layout();
    for (Iterator itr = getChildren().iterator(); itr.hasNext();)
        (cast(IFigure)itr.next()).validate();
}

/**
 * Sets the bidi level of the content box associated with this Figure
 * @see FlowFigure#setBidiInfo(BidiInfo)
 */
public void setBidiInfo(BidiInfo info) {
    box.setBidiLevel(info.levelInfo[0]);
}

/**
 * @see org.eclipse.draw2d.IFigure#setBounds(org.eclipse.draw2d.geometry.Rectangle)
 */
public void setBounds(Rectangle rect) {
    int x = bounds.x,
    y = bounds.y;

    bool resize = (rect.width !is bounds.width) || (rect.height !is bounds.height),
          translate = (rect.x !is x) || (rect.y !is y);

    if ((resize || translate) && isVisible())
        erase();
    if (translate) {
        int dx = rect.x - x;
        int dy = rect.y - y;
        primTranslate(dx, dy);
    }

    bounds.width = rect.width;
    bounds.height = rect.height;

    if (translate || resize) {
        fireFigureMoved();
        repaint();
    }
}

/**
 * @see FlowFigure#setFlowContext(FlowContext)
 */
public void setFlowContext(FlowContext flowContext) {
    context = flowContext;
}

/**
 * Do not validate children.
 * @see org.eclipse.draw2d.IFigure#validate()
 */
public void validate() {
    if (isValid())
        return;
    setValid(true);
    layout();
}

private class FigureBox : ContentBox {
    private int ascent;
    public bool containsPoint(int x, int y) {
        return this.outer.containsPoint(x, y);
    }
    public int getAscent() {
        return ascent;
    }
    public int getDescent() {
        return 0;
    }
    public void setSize(Dimension size) {
        ascent = size.height;
        width = size.width;
    }
}

}
