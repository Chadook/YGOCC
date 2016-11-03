--Girl of Stellar Vine
function c101010159.initial_effect(c)
--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCondition(c101010159.drcon)
	e1:SetTarget(c101010159.drtg)
	e1:SetOperation(c101010159.drop)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101010159)
	e2:SetLabel(0)
	e2:SetCondition(c101010159.con)
	e2:SetCost(c101010159.cost)
	e2:SetTarget(c101010159.tg)
	e2:SetOperation(c101010159.op)
	c:RegisterEffect(e2)
end
function c101010159.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x785e)
end
function c101010159.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.IsExistingMatchingCard(c101010159.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c101010159.filter(c)
	return c:IsLocation(LOCATION_REMOVED) and c:IsSetCard(0x785a)
end
function c101010159.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,nil)>2 end
	Duel.DisableShuffleCheck()
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local sg=g:FilterCount(c101010159.filter,nil)
	e:SetLabel(sg)
end
function c101010159.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end
function c101010159.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct==0 or ct>sg:GetCount() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=sg:Select(tp,ct,ct,nil)
	Duel.HintSelection(tc)
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101010159.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK+LOCATION_HAND)
end
function c101010159.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c101010159.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoGrave(c,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(101010159,0)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
