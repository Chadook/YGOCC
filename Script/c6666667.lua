--Medusa, Shaderune Gorgon
function c6666667.initial_effect(c)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6666667,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c6666667.bancon)
	e1:SetTarget(c6666667.bantg)
	e1:SetOperation(c6666667.banop)
	c:RegisterEffect(e1)
	--banish deck check
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6666667,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c6666667.condition)
	e2:SetTarget(c6666667.target)
	e2:SetOperation(c6666667.operation)
	c:RegisterEffect(e2)
end
function c6666667.bancon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c6666667.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c6666667.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c6666667.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6666667.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c6666667.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c6666667.banop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
		if tc:IsRelateToEffect(e) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		c:RegisterEffect(e1)
	end
end
function c6666667.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c6666667.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,LOCATION_DECK)
end
function c6666667.cfilter(c)
	return c:IsSetCard(0x900) or c:IsSetCard(0x901)
end
function c6666667.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		local sg=g:Filter(c6666667.cfilter,nil)
		if sg:GetCount()>0 then
			if sg:GetFirst():IsAbleToRemove() then
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
		Duel.ShuffleDeck(tp)
	end
end