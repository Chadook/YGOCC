--created & coded by Lyris
--S・VINE王子ザフィル
function c101010247.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return re:IsActiveType(TYPE_MONSTER) or re:GetHandler():IsType(TYPE_MONSTER) end)
	e1:SetTarget(c101010247.destg)
	e1:SetOperation(c101010247.desop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c101010247.discon)
	e4:SetTarget(c101010247.tg)
	e4:SetOperation(c101010247.op)
	c:RegisterEffect(e4)
end
function c101010247.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101010247.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c101010247.discon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	return ec==Duel.GetAttackTarget() or ec==Duel.GetAttacker() and ec:GetBattleTarget()
end
function c101010247.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc:IsControler(1-tp) and bc:IsControlerCanBeChanged() end
	Duel.SetTargetCard(bc)
end
function c101010247.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_FAIRY)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		tc:RegisterEffect(e2)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(ATTRIBUTE_WATER)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BATTLED)
		e3:SetOperation(c101010247.psop)
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		Duel.RegisterEffect(e3,tp)
	end
end
function c101010247.psop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetOwner():GetBattleTarget()
	if tg then
		Duel.GetControl(tg,tp,RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	end
end
