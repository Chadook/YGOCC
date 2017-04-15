--Kerberos, the Shaderune Hell Hound
function c6666669.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6666669,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetTarget(c6666669.target)
	e1:SetOperation(c6666669.operation)
	c:RegisterEffect(e1)
end
function c6666669.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return true end
	if Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(6666669,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	end
	if chk==0 then return Duel.GetDecktopGroup(tp,3):IsExists(Card.IsAbleToRemove,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,0,0)
end
function c6666669.cfilter(c)
	return c:IsSetCard(0x900) and c:IsLocation(LOCATION_REMOVED)
end
function c6666669.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		Duel.BreakEffect()
	end
    local g=Duel.GetDecktopGroup(tp,3)
    Duel.DisableShuffleCheck()
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    local og=Duel.GetOperatedGroup()
    local ct=og:FilterCount(c6666669.cfilter,nil)
    if ct>0 then
        Duel.BreakEffect()
        Duel.Draw(tp,ct,REASON_EFFECT)
    end
end
